# This file contains a utility to create custom error messages when a method
# has not been implemented.

# TODO: include method signature information for the unimplemented method

struct NotImplementedError <: Exception
    method::Symbol
end

NotImplementedError() = NotImplementedError(stacktrace()[2].func)

Base.showerror(io::IO, e::NotImplementedError) = print(io, e.method, "() is missing a concrete implementation")
