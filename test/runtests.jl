using PIEMetData, TidalFluxExampleData, TidalFluxConfigurations, Base.Dates
using Base.Test

TidalFluxConfigurations.config[:_METDATA_DIR] = Pkg.dir("TidalFluxExampleData","data","met")
@testset "parsemet" begin
    M = parsemet(2016)
    @test year.(M[:DateTime])[1] == 2016
    @test year.(M[:DateTime])[end] == 2017
end

@testset "Error handling" begin
    @test_throws ErrorException parsemet(2010)
end
