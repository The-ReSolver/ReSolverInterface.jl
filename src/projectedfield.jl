# Definitions for a concrete implementation of a projected scalar field built
# upon the abstract interface defined for the generic scalar field.

# This type technically breaks what is expected from the abstractscalarfield
# interface. This is not a massive problem since its workings should remain
# internal and therefore does not have expose a faulty implementation to the
# user.

struct ProjectedField{S<:AbstractScalarField, N, T, M} <: AbstractScalarField{N, T}
    modes::M
    field::S

    ProjectedField(field::S, modes) where {N, T, S<:AbstractScalarField{N, T}} = new{S, N, T, typeof(modes)}(modes, field)
end

# ! required !
expand!(u::VectorField{M, S}, a::ProjectedField{S, N}) where {N, M, S<:AbstractScalarField{N}} = throw(NotImplementedError(u, a))
project!(a::ProjectedField{S, N}, u::VectorField{M, S}) where {N, M, S<:AbstractScalarField{N}} = throw(NotImplementedError(a, u))

Base.parent(a::ProjectedField) = parent(a.field)
Base.similar(a::ProjectedField, ::Type{T}) where {T} = ProjectedField(similar(a.field, T), a.modes)

# ! required !
LinearAlgebra.dot(u::P, v::P) where {P<:ProjectedField} = throw(NotImplementedError(u, v))
