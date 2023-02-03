module Documents

using MLStyle
include("Preambles.jl")
import .Preambles


abstract type AbstractItem end

struct Body
    items
end

struct TOC <: AbstractItem end
write_item(::TOC, parents) = "\\tableofcontents"

struct MakeTitle <: AbstractItem end
write_item(::MakeTitle, parents) = "\\maketitle"

struct Section <: AbstractItem
    name
    content
end

@data Environment<:AbstractItem begin
    Align


struct Document
    preamble::Preambles.Preamble
    body::Body
    function Document(preamble, body)
        if Preambles.infer_pkg_deps ∈ preamble
            new(append!(preamble, Preambles.infer_pkg_deps(body)), body)
        else
            new(preamble, body)
        end
    end
end


function julia2latex(document::Document)
    preamble_text = Preambles.build_preamble(document.preamble)
    body_text = ""
    "\\begin{document}\n$(preamble_text)\n$(body_text)\\end{document}"
end


end
