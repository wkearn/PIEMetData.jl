using PIEMetData, TidalFluxExampleData
using Base.Test

setmetdatadir!(Pkg.dir("TidalFluxExampleData","data","met"))
M = parsemet(2016)
@test year.(M[:DateTime])[1] == 2016
@test year.(M[:DateTime])[end] == 2017
