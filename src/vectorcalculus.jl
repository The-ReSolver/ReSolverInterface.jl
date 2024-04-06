# This file contains the definitions required to perform vector calculus
# operatiosn of the abstract and concrete fields defined elsewhere.

# ! required !
"""
    grad!(
        ∇u::AbstractScalarField,
        u::AbstractScalarField
    ) -> AbstractScalarField

Compute the gradient of the scalar field u, overwriting ∇u with the result.
"""
grad!(∇u::V, u::S) where {N, S<:AbstractScalarField, V<:AbstractVectorField{N, S}} = throw(NotImplementedError(∇u, u))


# ! required !
"""
    divergence!(
        div_u::AbstractScalarField,
        u::AbstractVectorField
    ) -> AbstractScalarField

Compute the divergence of a vector field, overwriting the output into div_u.
"""
divergence!(div_u::S, u::V) where {N, S<:AbstractScalarField, V<:AbstractVectorField{N, S}} = throw(NotImplementedError(div_u, u))


# ! required !
"""
    laplacian!(
        Δu::AbstractScalarField,
        u::AbstractScalarField
    ) -> AbstractScalarField

Compute the Laplacian of the scalar field u, overwriting Δu with the result.
"""
laplacian!(Δu::S, u::S) where {S<:AbstractScalarField} = throw(NotImplementedError(Δu, u))

# * optional *
"""
    laplacian!(
        Δu::AbstractScalarField,
        u::AbstractScalarField
    ) -> AbstractScalarField

Compute the Laplacian of the vector field u, overwriting Δu with the result.

WARNING: The default implementation assumes cartesian coordinates
"""
function laplacian!(Δu::AbstractVectorField{N, S}, u::AbstractVectorField{N, S}) where {N, S}
    for i in 1:N
        laplacian!(Δu[i], u[i])
    end
    return Δu
end

# ! required !
"""
    convection!(
        u∇v::AbstractVectorField,
        u::AbstractVectorField,
        v::AbstractVectorField
    ) -> AbstractVectorField

Compute the nonlinear convection of a vector field, overwriting the output into
u∇v.
"""
convection!(u∇v::V, u::V, v::V) where {V<:AbstractVectorField} = throw(NotImplementedError(u∇v, u, v))
convection!(u∇u::V, u::V) where {V<:AbstractVectorField} = convection!(u∇u, u, u)


# ! required !
"""
    ddt!(
        dudt::AbstractScalarField,
        u::AbstractScalarField
    ) -> AbstractScalarField

Compute the time derivative of the scalar field u, overwriting dudt with the
result
"""
ddt!(dudt::S, u::S) where {S<:AbstractScalarField} = throw(NotImplementedError(dudt, u))
ddt!(dudt::AbstractVectorField{N, S}, u::AbstractVectorField{N, S}) where {N, S} = ddt!.(dudt, u)
