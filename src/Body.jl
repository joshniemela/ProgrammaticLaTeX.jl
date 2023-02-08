import Base.show
using MLStyle
struct LaTeXEnv{T, C}
  symbol::Val{T}
  content::C
  args::Dict{String, <: Union{Int, Bool}}
  numbered::F where {F <: Union{Nothing, Bool}}
end
LaTeXEnv(symbol::Symbol, content, args) = LaTeXEnv(Val(symbol), content, args)

struct Section{T}
    name::String
    content::T
    numbered::F where {F <: Union{Nothing, Bool}}
end

struct TOC end
interpret_item(::TOC) = "\\tableofcontents"

struct MakeTitle end
interpret_item(::MakeTitle) = "\\maketitle"

show(io::IO, ::MIME"text/plain", x::Union{Section, LaTeXEnv}) = print(io, interpret_item(x))

""" If not a section then just dispatch to 1 arg version of interpret"""
interpret_item(x, _) = interpret_item(x)
interpret_item(x::String) = x
function interpret_item(sec::Section, depth=1)
    star = sec.numbered ? "" : "*"
    section_name = @match depth begin
        1 => "section"
        2 => "subsection"
        3 => "subsubsection"
        4 => "paragraph"
        5 => "subparagraph"
        _ => throw(ArgumentError("Indent level: $depth not supported by LaTeX"))
    end

    section_head = join(["\\", section_name, star, "{$(sec.name)}"])

    join([section_head, "\n", interpret_item(sec.content, depth+1)])
end

""" Map interpret across any vector like content """
interpret_item(items::Vector{T}, depth) where {T} = join(interpret_item.(items, depth), "\n")
#=
# Broadcast interpret_item recursively if an iterable is given
function interpret_item(content::AbstractVector; numbered=true, depth=0)
    out = ""
    for element in content
        out = string(out, interpret_item(element; numbered=numbered, depth=depth+1)*"\n")
    end

    out
end

function interpret_item(section::Section; kwargs...)
    name = section.name
    star = kwargs[:numbered] ? "" : "*"
    section_name = @match kwargs[:depth] begin
        1 => "\\section$star{$name}"
        2 => "\\subsection$star{$name}"
        3 => "\\subsubsection$star{$name}"
        4 => "\\paragraph$star{$name}"
        5 => "\\subparagraph$star{$name}"
        _ => throw(ArgumentError("Indent level: $(kwargs[:depth]) not supported by LaTeX"))
    end 
    join([section_name, interpret_item(section.content; kwargs...)], "\n")
end

function interpret_item(env::Environment; kwargs...)
    envName = env.env |> String
    star = kwargs[:numbered] ? "" : "*"
    """
    \\begin{$envName$star}
    $(interpret_item(env.content))
    \\end{$envName$star}
    """
end


function interpret_item(plot::Plots.Plot; kwargs...)
    path = tempname()
    savefig(plot, path)
    "\\includegraphics{$path}"
end

align(content) = Environment(:align, content)
eq(content) = Environment(:equation, content)
equation(content) = Environment(:equation, content)
figure(content) = Environment(:figure, content)
=#
