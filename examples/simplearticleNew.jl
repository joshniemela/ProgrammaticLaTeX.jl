using ProgrammaticLaTeX
using Plots # for plot()
using Dates # for today()
using Pipe
preamble = Preamble([
    [Author(["Josh", "University of Copenhagen"]),
        Author(["Other author", "Something"])],
    today(),
    Title("Simple document with Julia")],
    LaTeXArgs()
)

body = [
    MakeTitle(),

    "Stuff immediately after the title, filler words here",

    Section("First section", 
        eq( 
            "ℙ(A) ≥ 0 ∀ A ⊂ S ■"
        ),
        "The first axiom of probability",

        Section("Second section nested within the first",
            "Stuff here",
            figure(
                plot(x -> x^2)
            )
        )
    )
]

@pipe julia2latex(preamble, body) |> buildPDF(_, "testOutput")
