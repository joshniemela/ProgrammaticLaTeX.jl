# Credits to the developers of LaTeXStrings https://github.com/stevengj/LaTeXStrings.jl for various lines of code used in this file.
struct JString <: AbstractString
    s::String
end
jstring(args...) = jstring(string(args...))
jstring(s::AbstractString) = jstring(String(s))

#=
TODO:
The following code might not be able to express half-open set intervals such as (x]
=#
function parse_mathmode(str)
    terminators = [' ', '.', ',', ';', ':', '!', '?', '\n', '\t']
    new_str = ""
    head = tail = firstindex(str)
    in_math = false
    brackets = nothing :: Union{Nothing, Bool}

    while head <= lastindex(str)
        # If ! is found, enter math mode
        if !in_math && str[head] == '!'
            # If ( is also found, we're in bracketed math mode
            if str[nextind(str, head)] == '('
                brackets = 1
                new_str *= str[tail:prevind(str, head)] * "\\("
                head = nextind(str, head)
            # Else, we're in unbracketed math mode
            else
                brackets = nothing
                new_str *= str[tail:prevind(str, head)] * "\\("
            end

            in_math = true
            head = tail = nextind(str, head)
        end

        # Deal with unbracketed math
        if in_math && isnothing(brackets) && str[head] in terminators
            # This is to catch any !'s immediately followed by a terminator
            if str[head] == '!'
                error("Unmatched ! at index $(prevind(str, head, 2))")
            end
            
            new_str *= str[tail:prevind(str, head)] * "\\)"
            tail = head
            in_math = false
        end
        
        # Deal with bracketed math
        if in_math && !isnothing(brackets)
            if str[head] == '('
                brackets += 1
            elseif str[head] == ')'
                brackets -= 1
            end

            # If bracket == 0, we're done with the math mode
            if brackets == 0
                new_str *= str[tail:prevind(str, head)] * "\\)"
                tail = head
                in_math = false
                brackets = nothing
            end

        end

        # Finally, increment the head    
        head = nextind(str, head)
    end
    
    # Dealing with unmatched ('s
    if !isnothing(brackets)
        error("Unmatched ( at index $(prevind(str, head, 2))")
    end

    # Adding the last bit of the string
    if in_math
        new_str *= str[tail:lastindex(str)] * "\\)"
    else
        new_str *= str[tail:lastindex(str)]
    end

end

function parse_jstr(s)
    parse_mathmode(s) |> JString
end

macro J_str(s)
    expr = esc(Meta.parse("\"$(escape_string(s))\""))
    expr.args = map(expr.args) do arg
        subexpr = Expr(:call, Expr(:., :ProgrammaticLaTeX, QuoteNode(:parse_jstr)), arg)
        arg isa String ? subexpr : Expr(:string, subexpr)
    end
    return expr
end

function Base.show(io::IO, s::JString)
    print(io, "J\"")
    Base.escape_raw_string(io, s.s)
    print(io, '"')
end

Base.write(io::IO, s::JString) = write(io, s.s)

Base.firstindex(s::JString) = firstindex(s.s)
Base.lastindex(s::JString) = lastindex(s.s)
Base.iterate(s::JString, i::Int) = iterate(s.s, i)
Base.iterate(s::JString) = iterate(s.s)
Base.nextind(s::JString, i::Int) = nextind(s.s, i)
Base.prevind(s::JString, i::Int) = prevind(s.s, i)
Base.eachindex(s::JString) = eachindex(s.s)
Base.length(s::JString) = length(s.s)
Base.getindex(s::JString, i::Integer) = getindex(s.s, i)
Base.getindex(s::JString, i::Int) = getindex(s.s, i) # for method ambig in Julia 0.6
Base.getindex(s::JString, i::UnitRange{Int}) = getindex(s.s, i)
Base.getindex(s::JString, i::UnitRange{<:Integer}) = getindex(s.s, i)
Base.getindex(s::JString, i::AbstractVector{<:Integer}) = getindex(s.s, i)
Base.getindex(s::JString, i::AbstractVector{Bool}) = getindex(s.s, i) # for method ambiguity
Base.codeunit(s::JString, i::Integer) = codeunit(s.s, i)
Base.codeunit(s::JString) = codeunit(s.s)
Base.ncodeunits(s::JString) = ncodeunits(s.s)
Base.codeunits(s::JString) = codeunits(s.s)
Base.sizeof(s::JString) = sizeof(s.s)
Base.isvalid(s::JString, i::Integer) = isvalid(s.s, i)
Base.pointer(s::JString) = pointer(s.s)
Base.IOBuffer(s::JString) = IOBuffer(s.s)
Base.unsafe_convert(T::Union{Type{Ptr{UInt8}},Type{Ptr{Int8}},Cstring}, s::JString) = Base.unsafe_convert(T, s.s)
Base.match(re::Regex, s::JString, idx::Integer, add_opts::UInt32=UInt32(0)) = match(re, s.s, idx, add_opts)
Base.findnext(re::Regex, s::JString, idx::Integer) = findnext(re, s.s, idx)
Base.eachmatch(re::Regex, s::JString; overlap = false) = eachmatch(re, s.s; overlap=overlap)
