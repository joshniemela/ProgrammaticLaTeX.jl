module ProgrammaticLaTeX
using Dates

# Stuff that isn't present in the acutal finished document, contains metadata other things
abstract type AbstractDecl end

struct DocumentClass <: AbstractDecl
    class::AbstractString
    options::Vector{AbstractString}
end
DocumentClass(class::AbstractString) = DocumentClass(class, [""]) # If no settings are given

struct Author <: AbstractDecl
    name::Vector{AbstractString}
end
Author(name::AbstractString) = Author([name])

struct Authors <: AbstractDecl
    authors::Vector{Author}
end

struct Title <: AbstractDecl
    text::AbstractString
end

# Used if the builtin functions lack something
struct Include <: AbstractDecl
    path::AbstractString
end

# \\ separate within author entry
# \and to separate authors
# \AND to separete authors more



struct TOC <: AbstractDecl
end

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

        new(preamble, content)
    end
end

function write_decl(docclass::DocumentClass)
    if isempty(docclass.options)
        "\\documentclass{$(docclass.class)}"
    else
        "\\documentclass[$(join(d.settings, ','))]{$(docclass.class)}"
    end
end


doc = Document([
  DocumentClass("article"),
  TOC(),
  Author("Joshua Niemelä"),
  Author(["Jakup Lützen", "Hold 3"]),
  Date("2022-01-31")],

  []
)

function julia2latex(document::Document)
    output = ""
end

end
