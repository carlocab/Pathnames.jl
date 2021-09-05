# Pathnames

Do you hate writing `joinpath(prefix, libdir, libsudbir, libname)`? Use `Pathnames` and you won't have to.

If you find this package useful, please give it a star.

## Installation

```julia
using Pkg; Pkg.add("https://github.com/carlocab/Pathnames.jl")
```

## Usage

`Pathnames` is a small library designed to make working with paths in the file system easier. Here's a quick REPL-based summary:

```julia
julia> using Pathnames

julia> prefix = p"/usr/local"
p"/usr/local"

julia> prefix isa Pathname
true

julia> prefix === pathname("/usr/local")
true

julia> julia_bin = p"bin/julia"
p"bin/julia"

julia> path = prefix/julia_bin
p"/usr/local/bin/julia"

julia> path isa Pathname
true

julia> path === joinpath(prefix, julia_bin) === pathname("/usr/local", "bin/julia") === prefix/"bin/julia"
true
```

`Pathnames` exports:
1. a `Pathname` type, which represents the name of a file or directory in the file system;
2. a `pathname` function, analogous to the `string` function in `Base`;
3. a `PathnameWrapper` module which provides alternate definitions of some functions in `Base`; and,
4. a `p"..."` macro to simplify the definition of `Pathname`s.

We add methods to functions in `Base.Filesystem`. Nearly all of these methods have the same semantics as the ones they replace. The sole exception is `/`, the default Unix path-separator, which we use `/` as shorthand for `joinpath`:

```julia
julia> path = p"/tmp"
p"/tmp"

julia> path/"foo" === pathname(path, "foo")
true
```

`Pathname`s are `AbstractString`s. The term `Pathname` is borrowed from the [Ruby class of the same name](https://ruby-doc.org/stdlib-3.0.2/libdoc/pathname/rdoc/Pathname.html), but, at the time of writing, the only similarity is our definition of the `/` operator.

Let `f` be a function defined in `Base.Filesystem` and documented in the [Julia Documentation](https://docs.julialang.org) (e.g. `joinpath`). There are two design principles we use for defining methods for `f`:

1. If `f` takes an `AbstractString` and returns an `AbstractString`, then `f` returns a `Pathname` when given a `Pathname`.
2. If `f` takes multiple `AbstractString`s and returns an `AbstractString`, then `f` returns a `Pathname` when given a `Pathname` as its first or second argument.

```julia
julia> touch(p"/tmp/foo") isa Pathname
true

julia> joinpath(p"/tmp", "foo") isa Pathname
true

julia> joinpath("/tmp", p"foo") isa Pathname
true

julia> joinpath("/tmp", "foo", p"bar") isa Pathname
false
```

We dispatch to `Pathname` methods on the second argument to enable use with Julia-provided constants.

```julia
julia> Sys.BINDIR/p"julia"
p"/usr/local/bin/julia"
```

`PathnameWrapper` is a module that exports no functions but provides alternate definitions for functions in `Base` that don't give us the opportunity to exploit multiple dispatch.

```julia
julia> using Pathnames: PathnameWrapper as p

julia> p.pwd()
p"/Users/carlocab/.julia/dev/Pathnames"

julia> p.homedir()
p"/Users/carlocab"
```
