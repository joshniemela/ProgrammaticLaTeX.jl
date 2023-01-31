using ProgrammaticLaTeX
using Documenter

DocMeta.setdocmeta!(ProgrammaticLaTeX, :DocTestSetup, :(using ProgrammaticLaTeX); recursive=true)

makedocs(;
    modules=[ProgrammaticLaTeX],
    authors="Joshua Niemelä <josh@jniemela.dk> and contributors",
    repo="https://github.com/joshniemela/ProgrammaticLaTeX.jl/blob/{commit}{path}#{line}",
    sitename="ProgrammaticLaTeX.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://joshniemela.github.io/ProgrammaticLaTeX.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/joshniemela/ProgrammaticLaTeX.jl",
    devbranch="main",
)
