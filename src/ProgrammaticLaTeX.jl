include("Preamble.jl")

module ProgrammaticLaTeX
end

preamble = Preamble(
  DocumentClass("article"),
  Author("Joshua Niemelä"),
  Author(["Jakup Lützen", "Hold 3"]),
  Date("2022-01-31"),
  Title("Test 101")
)
