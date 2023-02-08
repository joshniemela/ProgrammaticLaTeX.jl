struct Author
    fields::Vector{AbstractString}
end
Author(name::AbstractString) = Author([name])

struct Title
    text::AbstractString
end

const LaTeXArg = Pair{String, Union{Int, Bool, String}}
const LaTeXArgs = Dict{String, Union{Int, Bool, String}}
 
struct Package
    name::AbstractString
    args::LaTeXArgs
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

struct Preamble{T}
    declarations::Vector{T}
    defaultArgs::LaTeXArgs
end

function interpret_decl(arg::LaTeXArg)
    @match Tuple(arg) begin
        (_, false) => ""
        (a, true) => a
        (a, b) => a*"="*string(b)
    end
end

function interpret_decl(args::LaTeXArgs)
    @pipe args |> collect .|> interpret_decl |> filter!(!=(""), _) |> join(_, ",")
end

interpret_decl(authors::Vector{Author}) = @pipe authors .|> 
    join(_.fields, " \\\\ ") |>
    join(_, " \\and ") |> 
    "\\author{$_}"

interpret_decl(date::Date) = "\\date{$date}"

interpret_decl(title::Title) = "\\title{$(title.text)}"

interpret_decl(package::Package) = "\\usepackage[$(interpret_decl(package.args))]{$(package.name)}"
Package(name) = Package(name, LaTeXArgs())

build_preamble(preamble) = @pipe preamble.declarations .|> interpret_decl |> join(_, "\n")

const default_pkgs = ["graphicx", "microtype", "amsmath", "amssymb", "hyperref", "fancyhdr", "unicode-math"] .|> Package

