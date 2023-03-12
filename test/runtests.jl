using ProgrammaticLaTeX
using Test

@testset "ProgrammaticLaTeX.jl" begin
    # Test that JString works as expected
    @testset "Testing intended behaviour of JString" begin
        @test J"S" == "S"
        @test J"\frac{1}{2}" == "\\frac{1}{2}"
        @test J"!(\frac{1}{2})" == "\\(\\frac{1}{2}\\)"
        @test J"!n" == "\\(n\\)"
    end

    # Assert that it errors when given invalid input
    @testset "Testing erors of JString" begin
    @test_throws ErrorException J"!"
    @test_throws ErrorException J"! "
    @test_throws ErrorException J"!("
    @test_throws ErrorException J"!( "
    @test_throws ErrorException J"!()"
    @test_throws ErrorException J"!(\frac{1}{2}"
    end
end
