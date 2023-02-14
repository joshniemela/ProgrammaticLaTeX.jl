macro document(preamble, content...)

end


function parseOptions(options)
    optionDict = Dict{Symbol, Union{Symbol, Bool, Nothing, Int}}()

    # If it is only a single option / expr then turn into list
    if options isa Symbol || options.head == :(=)
        options = :[$options]
    end

    for option in options.args
        if option isa Symbol
            optionDict[option] = true

        elseif option.head == :(=)
            optionDict[option.args[1]] = option.args[2]

        elseif option.args[1] == :!
            optionDict[option.args[2]] = false 
        end
    end

    optionDict
end

macro section(name, content)
   newContent = filter(x -> !(x isa LineNumberNode), content.args)

   return :(
       Section(
           $name,
           [$(newContent...)],
           nothing,
       )
   )
end

macro section(name, args, content)
    options = parseOptions(args)
    newContent = filter(x -> !(x isa LineNumberNode), content.args)
    return :(
        Section(
           $name,
           [$(newContent...)],
           get($options, :numbered, nothing),
        )
    )
end




preamble=Dict(:numbered=false)

@document preamble begin
    @section "name" begin
        content
    end
end

interpret_item(section, preamble) 
    interpret_item(section.content, preamble where depth + 1)
