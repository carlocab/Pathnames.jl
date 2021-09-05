baremodule Pathnames

export Pathname, pathname, @p_str

import Base
using Base: AbstractString, getproperty, include,
            @__MODULE__, unescape_string, QuoteNode,
            print, IO

struct Pathname{T<:AbstractString} <: AbstractString
    path::T
end

# We don't want objects of type `Pathname{Pathname{T}}`
Pathname(p::Pathname) = Pathname(p.path)

import Base.show
show(io::IO, p::Pathname) = print(io, "p\"", p.path, "\"")

import Base.joinpath
pathname(s::AbstractString) = Pathname(s)
pathname(p::Vararg{AbstractString}) = pathname(joinpath(p...))

macro p_str(s::AbstractString)
    # Do I really need `unescape_string` here?
    # Borrowed from the definition of `b_str` in base/strings/io.jl.
    # I don't think it hurts.
    p = pathname(unescape_string(s))
    QuoteNode(p)
end

joinpath(x::Vararg{Pathname}) = pathname(joinpath(getproperty.(x, :path)...))
joinpath(x::Pathname, y::Vararg{AbstractString}) = joinpath(x, pathname.(y)...)
joinpath(x::AbstractString, y::Pathname, z::Vararg{AbstractString}) = joinpath(pathname(x), y, pathname.(z)...)
joinpath(x::Pathname, y::Pathname, z::Vararg{AbstractString}) = joinpath(x, y, pathname.(z)...)

import Base.ncodeunits
ncodeunits(p::Pathname) = ncodeunits(p.path)

import Base.iterate
iterate(p::Pathname) = iterate(p.path)
iterate(p::Pathname, i::Integer) = iterate(p.path, i)

import Base.isvalid
isvalid(p::Pathname, i::Integer) = isvalid(p.path, i)

import Base.:(/)
/(x::Vararg{Pathname}) = joinpath(x...)
/(x::Pathname, y::Vararg{AbstractString}) = joinpath(x, y...)
/(x::AbstractString, y::Pathname, z::Vararg{AbstractString}) = joinpath(x, y, z...)
/(x::Pathname, y::Pathname, z::Vararg{AbstractString}) = joinpath(x, y, z...)

import Base.readdir
function readdir(dir::Pathname; join::Bool=false, sort::Bool=true)
    pathname.(readdir(dir.path, join=join, sort=sort))
end

import Base.readlink
readlink(p::Pathname) = pathname(readlink(p.path))

import Base.chmod
chmod(p::Pathname, mode::Integer; recursive::Bool=false) = pathname(chmod(p.path, mode, recursive=recursive))

import Base.chown
chown(p::Pathname, owner::Integer, group::Integer=-1) = pathname(chown(p.path, owner, group))

import Base.cp
function cp(src::Pathname, dst::Pathname; force::Bool=false, follow_symlinks::Bool=false)
    pathname(cp(src.path, dst.path, force=force, follow_symlinks=follow_symlinks))
end

function cp(src::Pathname, dst::AbstractString; force::Bool=false, follow_symlinks::Bool=false)
    cp(src, pathname(dst), force=force, follow_symlinks=follow_symlinks)
end

function cp(src::AbstractString, dst::Pathname; force::Bool=false, follow_symlinks::Bool=false)
    cp(pathname(src), dst, force=force, follow_symlinks=follow_symlinks)
end

import Base.mv
function mv(src::Pathname, dst::Pathname; force::Bool=false)
    pathname(mv(src.path, dst.path, force=force))
end

function mv(src::Pathname, dst::AbstractString; force::Bool=false)
    mv(src, pathname(dst), force=force)
end

function mv(src::AbstractString, dst::Pathname; force::Bool=false)
    mv(pathname(src), dst, force=force)
end

import Base.touch
touch(p::Pathname) = pathname(touch(p.path))

import Base.tempname
tempname(parent::Pathname; cleanup=true) = pathname(tempname(parent.path, cleanup=cleanup))

import Base.mktemp
function mktemp(parent::Pathname; cleanup=true)
    path, io = mktemp(parent.path, cleanup=cleanup)
    pathname(path), io
end

import Base.mktempdir
mktempdir(parent::Pathname; prefix="jl_", cleanup=true) = pathname(mktempdir(parent.path, prefix=prefix, cleanup=cleanup))

import Base.dirname
dirname(p::Pathname) = pathname(dirname(p.path))

import Base.basename
basename(p::Pathname) = pathname(basename(p.path))

import Base.abspath
abspath(p::Pathname) = pathname(abspath(p.path))
abspath(p::Pathname, paths::Vararg{Pathname}) = pathname(abspath(p.path, getproperty.(paths, :path)...))
abspath(p::Pathname, paths::Vararg{AbstractString}) = abspath(p, pathname.(paths)...)
abspath(p::AbstractString, paths::Vararg{Pathname}) = abspath(pathname(p), paths...)
abspath(p::AbstractString, q::Pathname, paths::Vararg{AbstractString}) = abspath(pathname(p), q, pathname.(paths)...)
abspath(p::Pathname, q::Pathname, paths::Vararg{AbstractString}) = abspath(p, q, pathname.(paths)...)

import Base.normpath
normpath(p::Pathname) = pathname(normpath(p.path))

import Base.realpath
realpath(p::Pathname) = pathname(realpath(p.path))

import Base.relpath
relpath(p::Pathname, startpath::Pathname = pathname(".")) = pathname(relpath(p.path, startpath.path))
relpath(p::Pathname, startpath::AbstractString) = relpath(p, pathname(startpath))
relpath(p::AbstractString, startpath::Pathname) = relpath(pathname(p), startpath)

import Base.expanduser
expanduser(p::Pathname) = pathname(expanduser(p.path))

import Base.splitdir
splitdir(p::Pathname) = pathname.(splitdir(p.path))

import Base.splitdrive
splitdrive(p::Pathname) = pathname.(splitdrive(p.path))

import Base.splitext # Do I really want the extension to be a Pathname?
splitext(p::Pathname) = pathname.(splitext(p.path))

import Base.splitpath
splitpath(p::Pathname) = pathname.(splitpath(p.path))

end # Pathnames
