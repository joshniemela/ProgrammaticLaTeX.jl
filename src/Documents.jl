module Documents
include("Preambles.jl")
import .Preambles

abstract type AbstractItem end

struct TOC <: AbstractItem end

struct Section <: AbstractItem
    content
end

struct Document
    preamble::Preambles.Preamble
    content
    function Document(preamble, content)
        if Preambles.infer_pkg_deps ∈ preamble
            new(append!(preamble, Preambles.infer_pkg_deps(content)), content)
        else
            new(preamble, content)
        end
    end
end


function julia2latex(document::Document)
    preamble_text = Preambles.build_preamble(document.preamble)

    content = "\\begin{document}\n"

    if any(x -> x isa Preambles.Title, document.preamble)
        content *= "\\maketitle\n"
    end

    "$(preamble_text)\n$(content)\\end{document}"
end


end
