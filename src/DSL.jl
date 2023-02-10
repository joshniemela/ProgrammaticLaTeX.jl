macro document(preamble, content...)

end

macro section(name, content)
    Section(
        interpret_item(name),
        content,
        nothing
    )
end

macro section(name, args, content)
    options = parseOptions(args)
    Section(
        interpret_item(name),
        content,
        get(options, :numbered, nothing)
    )
end




@section "name" [preambleArgs, optionA, optionB=2, !notOptionC] begin
    bla bla bla
    2x=2
end

preamble=Dict(:numbered=false)

@document preamble begin
    @section "name" begin
        content
    end
end

interpret_item(section, preamble) 
    interpret_item(section.content, preamble where depth + 1)
