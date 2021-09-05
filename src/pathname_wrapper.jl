baremodule PathnameWrapper

using ...Pathnames: pathname
import Base

pwd() = pathname(Base.pwd())

readdir(dir::AbstractString=Base.pwd(); join::Bool=false, sort::Bool=true) = pathname.(Base.readdir(dir, join=join, sort=sort))

tempname(parent = Base.tempdir(); cleanup=true) = pathname(Base.tempname(parent, cleanup=cleanup))

tempdir() = pathname(Base.tempdir())

mktempdir(parent=Base.tempdir(); prefix="jl_", cleanup=true) = pathname(Base.mktempdir(parent, prefix=prefix, cleanup=cleanup))

homedir() = pathname(Base.homedir())

end # Wrappers
