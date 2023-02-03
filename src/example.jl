
module ProgrammaticLaTeX
include("Preambles.jl")
include("Documents.jl")
end

preamble = Preamble(
  DocumentClass("article"),
  Author("Josh"),
  Author(["Jakup", "Hold 3"]),
  Date("2022-01-31"),
  Title("Test 101")
)


