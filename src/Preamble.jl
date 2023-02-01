module ProgrammaticLaTeX

export AbstractDecl, Author, DocumentClass, Title, Package, Preamble
export build_preamble

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

struct Package <: AbstractDecl
    pkgname::AbstractString
end

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

struct Preamble
    preamble
    function Preamble(preamble...)
        if length(filter(x -> x isa DocumentClass, preamble)) != 1
            error("DocumentClass needs one and only one definition.")
        end

        if length(filter(x -> x isa Date, preamble)) > 1
            error("Date cannot have more than one definition.")
        end

        new(merge_authors(preamble))
    end
end

function write_decl(docclass::DocumentClass)
    if isempty(docclass.options)
        "\\documentclass{$(docclass.class)}"
    else
        "\\documentclass[$(join(docclass.options, ','))]{$(docclass.class)}"
    end
end

write_decl(authors::Vector{Author}) = @pipe authors .|> 
    join(_.fields, " \\\\ ") |>
    join(_, " \\and ") |> 
    "\\author{$_}"

write_decl(date::Date) = "\\date{$date}"

write_decl(title::Title) = "\\title{$(title.text)}"

write_decl(package::Package) = "\\usepackage{$(package.pkgname)}"


build_preamble(declarations) = @pipe declarations .|> write_decl |> join(_, "\n")


#=function infer_pkg_deps(content)::Vector{Package}
 FUNCTION SHOULD LOOK AT CONTENT AND INFER WHAT USEPACKAGES TO INCLUDE
end=#

#=function julia2latex(document::Document)
    preamble = build_preamble(document.preamble)

    content = "\\begin{document}\n"

    if any(x -> x isa Title, document.preamble)
        content *= "\\maketitle\n"
    end

    "$(preamble)\n$(content)\\end{document}"
end=#


end
