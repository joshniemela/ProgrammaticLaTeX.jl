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

