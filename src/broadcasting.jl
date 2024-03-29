# This file contains the interface definitions required to get broadcasting
# as desired for concrete scalar and vector fields. Mainly this is to ensure
# that broadcasting on vector fields propagates into the underlying scalar
# field.

# Broadcasting for scalar fields should have the following behaviour                                     ✓
#   - any scalar should be applied to every elements                                                     ✓
#   - any array of N-dimensions should be expanded upon the M-N remaining dimensions of the scalar field ✓

# Broadcasting for vector fields should have the following behaviour                                    ✓
#   - a scalar should propagate into a broadcast along each scalar field component                      ✓
#   - a vector should have each of its elements broadcasted to the corresponding scalar field component ✓

Base.BroadcastStyle(u::Type{<:AbstractScalarField}) = Base.Broadcast.ArrayStyle{u}()
Base.similar(bc::Base.Broadcast.Broadcasted{Base.Broadcast.ArrayStyle{S}}, ::Type{T}) where {T, S<:AbstractScalarField} = similar(find_field(bc), T)

Base.BroadcastStyle(q::Type{<:AbstractVectorField{N}}) where {N} = Base.Broadcast.ArrayStyle{q}()
Base.similar(bc::Base.Broadcast.Broadcasted{Base.Broadcast.ArrayStyle{V}}, ::Type{T}) where {T, N, V<:AbstractVectorField{N}} = similar(find_field(bc), T)

Base.BroadcastStyle(::Base.Broadcast.ArrayStyle{V}, ::Base.Broadcast.ArrayStyle{S}) where {V<:AbstractVectorField, S<:AbstractScalarField} = Base.Broadcast.ArrayStyle{V}()

find_field(bc::Base.Broadcast.Broadcasted) = find_field(bc.args)
find_field(args::Tuple) = find_field(find_field(args[1]), Base.tail(args))
find_field(a::AbstractVectorField, ::Any) = a
find_field(a::AbstractScalarField, ::Any) = a
find_field(::Any, rest) = find_field(rest)
find_field(x) = x
find_field(::Tuple{}) = nothing

# TODO: can't do negation???
# TODO: does flatten actually work, do I need to unpack recursively???
function Base.copy(bc::Base.Broadcast.Broadcasted{Base.Broadcast.ArrayStyle{V}}) where {N, V<:AbstractVectorField{N}}
    dest = similar(bc, eltype(find_field(bc)[1]))

    for i in 1:N
        broadcast!(bc.f, dest[i], unpack(Base.Broadcast.flatten(bc), i)...)
    end

    return dest
end

function Base.copyto!(dest::VectorField{N}, bc::Base.Broadcast.Broadcasted{Base.Broadcast.ArrayStyle{V}}) where {N, V<:AbstractVectorField{N}}
    for i in 1:N
        broadcast!(bc.f, dest[i], unpack(Base.Broadcast.flatten(bc), i)...)
    end

    return dest
end

# TODO: is there a way to make this not use an abstract collection???
unpack(bc::Base.Broadcast.Broadcasted, i::Int) = unpack(bc.args, i, [])
unpack(args::Tuple, i::Int, out::Vector) = (x = unpack(args[1], i); push!(out, x); unpack(x, Base.tail(args), i, out))
unpack(a::AbstractVector, i::Int) = a[i]
unpack(x, ::Int) = x
unpack(::Any, rest, i::Int, out::Vector) = unpack(rest, i, out)
unpack(::Tuple{}, ::Int, out::Vector) = out
