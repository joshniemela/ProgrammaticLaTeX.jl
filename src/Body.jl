export AbstractItem, TOC, MakeTitle, Section, Image, Plot, Style
export Environment, Raw
export Body

export align, eq, equation, figure
@data AbstractItem begin
    TOC()
    MakeTitle()
    Section(name, content)
    Image(image)
    Plot(plot)
    Style(style)
    Environment(env::Symbol, content)
    Raw(text)
end
Section(name, args...) = Section(name, [args...])

struct Body
    content
end
Body(args...) = Body([args...])

# Broadcast interpret_item recursively if an iterable is given
function interpret_item(content::AbstractVector; numbered=true, depth=0)
    out = ""
    for element in content
        out = string(out, interpret_item(element; numbered=numbered, depth=depth+1)*"\n")
    end

    out
end

function interpret_item(section::Section; kwargs...)
    name = section.name
    star = kwargs[:numbered] ? "" : "*"
    section_name = @match kwargs[:depth] begin
        1 => "\\section$star{$name}"
        2 => "\\subsection$star{$name}"
        3 => "\\subsubsection$star{$name}"
        4 => "\\paragraph$star{$name}"
        5 => "\\subparagraph$star{$name}"
        _ => throw(ArgumentError("Indent level: $(kwargs[:depth]) not supported by LaTeX"))
    end 
    join([section_name, interpret_item(section.content; kwargs...)], "\n")
end

function interpret_item(env::Environment; kwargs...)
    envName = env.env |> String
    star = kwargs[:numbered] ? "" : "*"
    """
    \\begin{$envName$star}
    $(interpret_item(env.content))
    \\end{$envName$star}
    """
end

interpret_item(raw::Raw; kwargs...) = raw.text
interpret_item(raw::String; kwargs...) = raw

interpret_item(::TOC, kwargs...) = "\\tableofcontents"

interpret_item(::MakeTitle; kwargs...) = "\\maketitle"

function interpret_item(plot::Plot; kwargs...)
    path = tempname()
    savefig(plot.plot, path)
    "\\includegraphics{$path}"
end

align(content) = Environment(:align, content)
eq(content) = Environment(:equation, content)
equation(content) = Environment(:equation, content)
figure(content) = Environment(:figure, content)
