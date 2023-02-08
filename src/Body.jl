import Base.show
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
interpret_item(x::AbstractString) = x
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
