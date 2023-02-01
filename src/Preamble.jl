module ProgrammaticLaTeX
using Dates
using Pipe
# Stuff that isn't present in the acutal finished document, contains metadata other things
abstract type AbstractDecl end

struct DocumentClass <: AbstractDecl
    class::AbstractString
    options::Vector{AbstractString}
end
DocumentClass(class::AbstractString) = DocumentClass(class, [""]) # If no settings are given

struct Author <: AbstractDecl
    fields::Vector{AbstractString}
end
Author(name::AbstractString) = Author([name])


struct Title <: AbstractDecl
    text::AbstractString
end

# Used if the builtin functions lack something
#struct Include <: AbstractDecl
#    path::AbstractString
#end

# \\ separate within author entry
# \and to separate authors
# \AND to separete authors more

"""
This collects all of the authors in the preamble and puts them into a list.
"""
function merge_authors(preamble)
    authors = Vector{Author}()
    notauthors =[]
    for decl in preamble
        decl isa Author ? push!(authors, decl) : push!(notauthors, decl)
    end
    
    push!(notauthors, authors)
end

#struct TOC <: AbstractDecl
#end NOT A DECLARATION!!!

struct Document
    preamble
    content

    function Document(preamble, content)
        if length(filter(x -> x isa DocumentClass, preamble)) != 1
            error("DocumentClass needs one and only one definition.")
        end

        if length(filter(x -> x isa Date, preamble)) > 1
            error("Date cannot have more than one definition.")
        end

        new(merge_authors(preamble), content)
    end
end

function write_decl(docclass::DocumentClass)
    if isempty(docclass.options)
        "\\documentclass{$(docclass.class)}"
    else
        "\\documentclass[$(join(docclass.options, ','))]{$(docclass.class)}"
    end
end

#write_decl(::TOC) = "\\tableofcontents"

write_decl(authors::Vector{Author}) = @pipe authors .|> 
    join(_.fields, " \\\\ ") |>
    join(_, " \\and ") |> 
    "\\author{$_}"

write_decl(date::Date) = "\\date{$date}"

write_decl(title::Title) = "\\title{$(title.text)}"




build_preamble(declarations) = @pipe declarations .|> write_decl |> join(_, "\n")


function julia2latex(document::Document)
    preamble = build_preamble(document.preamble)

    content = "\\begin{document}\n"

    if any(x -> x isa Title, document.preamble)
        content *= "\\maketitle\n"
    end

    "$(preamble)\n$(content)\\end{document}"
end


doc = Document([
  DocumentClass("article"),
  Author("Joshua Niemelä"),
  Author(["Jakup Lützen", "Hold 3"]),
  Date("2022-01-31"),
  Title("Test 101")],
  []
)
end
