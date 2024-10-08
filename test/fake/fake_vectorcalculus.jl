ReSolverInterface.grad!(∇u::VectorField{N, MyField}, u::MyField) where {N} = ([∇u[i] .= i.*1im.*u for i in eachindex(∇u)]; return ∇u)
ReSolverInterface.divergence!(div_u::MyField, u::VectorField{N, MyField}) where {N} = ([div_u .+= 5im.*u[i] for i in eachindex(u)]; return div_u)
ReSolverInterface.laplacian!(Δu::MyField, u::MyField) = (Δu[i] .= 5im.*u[i]; return Δu)
ReSolverInterface.convection!(u∇v::VectorField{N, MyField}, u::VectorField{N, MyField}, v::VectorField{N, MyField}) where {N} = ([u∇v[i] .= i.*1im.*u[i].*v[i] for i in eachindex(u∇v)]; return u∇v)
ReSolverInterface.convection2!(∇uv::VectorField{N, MyField}, u::VectorField{N, MyField}, v::VectorField{N, MyField}) where {N} = ([∇uv[i] .= i.*u[i].*v[i] for i in eachindex(∇uv)]; return u∇v)
