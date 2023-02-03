module ProgrammaticLaTeX
include("Preambles.jl")
include("Body.jl")
end

preamble = Preamble(
  Author(["Jakup", "Hold 3"]),
  Date("2022-01-31"),
  Title("Test 101")
)

function julia2latex(preamble::Preamble, body::Body; class=:document, kwargs...)
    print("hello $class")

end
