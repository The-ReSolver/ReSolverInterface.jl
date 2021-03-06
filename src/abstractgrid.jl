# This file contains the definitions required to define an abstract grid type.

abstract type AbstractGrid end

"""
    points(g::AbstractGrid) -> NTuple{3, Vector{Float64}}

Return a tuple of vectors representing the location of the points making up the
grid in each direction.
"""
points(::AbstractGrid) = error("Missing concrete method for points")

"""
    size(g::AbstractGrid) -> NTuple{3, Int}

Return the size of the grid as if it were an array.
"""
Base.size(g::AbstractGrid) = length.(points(g))

"""
    ==(g1::AbstractGrid, g2::AbstractGrid) -> Bool

Compare two grids to see if they are the same discrete representation of the
same domain.
"""
Base.:(==)(g1::AbstractGrid, g2::AbstractGrid) = (points(g1) == points(g2))
