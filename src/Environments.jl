struct Section{T}
    name::String
    content::T
    numbered::F where {F <: Union{Nothing, Bool}}
end

struct Figure{T}
    figure::T
    placement
    width
    height
    caption
    label
end

function parseOptions(options)
    optionDict = Dict{Symbol, Union{Symbol, Bool, Nothing, Int}}()

    for option in options.args
        if option isa Symbol
            optionDict[option] = true
            continue
        end

        if option.head == :(=)
            optionDict[option.args[1]] = option.args[2]
            continue
        end

        if option.args[1].args[1] == :!
            optionDict[option.args[2]] = false 
            continue
        end
    end

    optionDict
end

