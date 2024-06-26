# Definition of the cache object that keeps track of all the optimisation
# variables. In addition it will work as a functor to allow it to directly be
# used to compute the residuals.

struct Objective{S, T, D, N, B<:AbstractArray, M<:AbstractArray, NSE, VDE}
    grad::ProjectedField{D, S, T, M}
    cache::Vector{VectorField{N, S}}
    projectedCache::ProjectedField{S, D, T, M}
    base::B
    modes::M
    free_mean::Bool
    navierStokesOperator::NSE
    gradientOperator::VDE

    function Objective(::Type{S}, grid::AbstractGrid, N::Int, Re::Float64, modes::M, base::B, free_mean::Bool, navierStokesOperator=NavierStokesOperator(S, grid, Re), gradientOperator=GradientOperator(S, grid, Re)) where {S<:AbstractScalarField, M, B, T}
        # initialise residual gradient output
        grad = ProjectedField(modes, S(g))

        # initialise cache
        cache = [VectorField(S, g, N) for _ in 1:6]
        projectedCache = ProjectedField(modes, S(g))

        params = convert.(eltype(field), params)

        new{S, eltype(grad), ndims(grad), N, B, M, typeof(navierStokesOperator!), typeof(gradientOperator!)}(grad, cache, projectedCache, base, modes, params, free_mean, navierStokesOperator, gradientOperator)
    end
end

function (f::Objective{S})(a::ProjectedField{S}, compute_grad::Bool=true) where {S}
    # assign aliases
    u    = f.cache[1]
    dudt = f.cache[2]
    N_u  = f.cache[3]
    r    = f.cache[4]
    drdt = f.cache[5]
    M_ur = f.cache[6]
    s    = f.projectedCache[1]

    # expand velocity coefficients into velocity field
    expand!(u, a)

    # include the base profile
    include_base!(u, f.base)

    # compute local residual
    @. r = ddt!(dudt, u) - f.navierStokesOperator(N_u, u)
    expand!(r, project!(s, r))

    # compute gradient
    if compute_grad
        @. dRdu = ddt!(drdt, r) + f.gradientOperator(M_ur, u, r)
        project!(f.grad, dRdu)
    end

    return f.grad, norm(s)^2/volume(grid(u))
end

function (f::Objective{S})(F, G, a::ProjectedField{S}) where {S}
    G === nothing ? F = f(a, false)[2] : (F = f(a, true)[2]; G .= f.grad)
    return F
end
