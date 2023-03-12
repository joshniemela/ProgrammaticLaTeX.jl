struct JString <: AbstractString
    s::String
end

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

# exists if we need to make it more complex
parse_jstr(s) = parse_mathmode(s) |> JString

macro J_str(s)
    return :($s |> parse_jstr)
end
