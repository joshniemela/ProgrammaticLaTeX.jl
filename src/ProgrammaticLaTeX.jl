module ProgrammaticLaTeX
export buildPDF, julia2latex

using MLStyle
using Dates
using Pipe

include("Preamble.jl")
include("Body.jl")

preamble = Preamble(
  Author(["Josh", "Hold 5"]),
  Author(["Jakup", "Hold 3"]),
  Date("2022-01-31"),
  Title("Test 101"),
  default_pkgs...
)


function julia2latex(preamble::Preamble, body::Body; class=:article, kwargs...)
    preamble_str = build_preamble(preamble.preamble)
    body_str = interpret_item(body.content, numbered=false, depth=1)
    join(["\\documentclass{$(class |> String)}", preamble_str, "\\begin{document}", body_str, "\\end{document}"], "\n")
end

function buildPDF(latex, name; run_command=`latexmk -lualatex`)
    tempdir = mktempdir()
    file = open("$tempdir/main.tex", "w")
    write(file, latex)
    close(file)

    run(Cmd(run_command, dir=tempdir))

    cp("$(tempdir)/main.pdf", "$name.pdf"; force=true)
end


end
