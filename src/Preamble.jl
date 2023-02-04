export AbstractDecl, Author, Title, Package, Preamble

export default_pkgs #, infer_pkg_deps

# Stuff that isn't present in the acutal finished document, contains metadata other things
abstract type AbstractDecl end

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
        if length(filter(x -> x isa Date, preamble)) > 1
            error("Date cannot have more than one definition.")
        end

        new(merge_authors(preamble))
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

const default_pkgs = ["graphicx", "microtype", "amsmath", "amssymb", "hyperref", "fancyhdr", "unicode-math"] .|> Package

#="""
Configure the stuff for geometry, margins etc etc etc
"""
function mk_geometry_pkg(stuff)
    stuff
end=#

function infer_pkg_deps(content)::Vector{Package}
    Vector{Package}(Package("THIS IS NOT IMPLEMENTED")) # NOT IMPLEMENTED
end
