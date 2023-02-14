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

        elseif option.head == :(=)
            optionDict[option.args[1]] = option.args[2]

        elseif option.args[1] == :!
            optionDict[option.args[2]] = false 
        end
    end

    optionDict
end

