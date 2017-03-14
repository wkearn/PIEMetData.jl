using PIEMetData
using Base.Test

setmetdatadir!(Pkg.dir("TidalFluxExampleData","data","met"))
parsemet(2016)
