using Pathnames
using Test
using Pathnames: PathnameWrapper as p

@testset "Pathnames.jl" begin
    home = expanduser(p"~")
    @test home isa Pathname
    @test home == pathname(ENV["HOME"])

    root = p"/"
    usr = root/"usr"

    @test root isa Pathname
    @test usr isa Pathname
    @test root/usr isa Pathname
    @test root/usr == usr
    @test root/usr/"local" isa Pathname
    @test pathname(root, usr, "local") == p"/usr/local"
    @test pathname(root, usr, p"local", "bin") == p"/usr/local/bin"

    testpath = p.mktempdir()
    cd(testpath)

    @test testpath isa Pathname
    @test realpath(testpath) isa Pathname
    @test p.pwd() == realpath(testpath)

    testpath = realpath(testpath)
    foofile = testpath/"foo"

    @test dirname(foofile) == testpath
    @test abspath(p"foo") == foofile
    @test touch(foofile) isa Pathname
    @test isfile(foofile)

    barfile = testpath/"bar"
    symlink(foofile, testpath/"bar")
    @test islink(barfile)
    @test readlink(barfile) == foofile
    rm(barfile)

    data = "Hello, world!"
    open(foofile, "w") do io
        write(io, data)
    end

    cp(foofile, barfile)
    @test isfile(barfile)
    open(barfile, "r") do io
        @test read(io, String) == data
    end

    bazfile = testpath/"baz"
    mv(barfile, bazfile)
    @test !isfile(barfile)
    @test isfile(bazfile)
    open(bazfile, "r") do io
        @test read(io, String) == data
    end
end
