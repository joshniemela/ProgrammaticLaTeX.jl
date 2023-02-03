using MLStyle
include("Preambles.jl")

@data AbstractItem begin
    TOC()
    MakeTitle()
    Section(name, content)
    Image(ref, image, label)
    Style(style)
    Environment(env::Symbol, content)
end


struct Body
    content
end

write_item(::TOC) = "\\tableofcontents"

write_item(::MakeTitle) = "\\maketitle"

