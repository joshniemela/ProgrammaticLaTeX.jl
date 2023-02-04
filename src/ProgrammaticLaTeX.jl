module ProgrammaticLaTeX
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


function julia2latex(preamble::Preamble, body::Body; class=:document, kwargs...)
    preamble_str = build_preamble(preamble.preamble)
    body_str = interpret_item(body.content, numbered=false, depth=1)
    join([preamble_str, body_str], "\n")
end

end
