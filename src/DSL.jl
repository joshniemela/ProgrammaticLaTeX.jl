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

# Does the same as a section but has no name and returns a list of expressions instead of a section
macro join(content)
    newContent = filter(x -> !(x isa LineNumberNode), content.args)
    return :([$(newContent...)])
end

