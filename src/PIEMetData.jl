module PIEMetData

using TidalFluxConfigurations, DataFrames, CSV, Base.Dates

export parsemet

const metdatatypes = [Date, # Date
                      String, # Time
                      Int, # Julian day
                      Union{Missings.Missing,Float64}, # Precip
                      Float64, # Pyranometer
                      Float64, # PAR
                      Float64, # Temp
                      Float64, # RH                         
                      Float64, # Wind
                      Float64, # WindDir
                      Float64, # P
                      ]

function parsemet(year::Int,metdatadir=TidalFluxConfigurations.config[:_METDATA_DIR])
    ys = parse.(readdir(metdatadir))
    in(year,ys) || error("met data requested for unavailable year: $year")

    M = CSV.read(joinpath(TidalFluxConfigurations.config[:_METDATA_DIR],string(year),"met.csv"),
                 types=metdatatypes,
                 dateformat=DateFormat("dd-uuu-yyyy"))
    t = lpad.(M[:Time],5,"0") # Pad the time with zeros
    M[:DateTime] = DateTime(Dates.format(M[:Date],DateFormat("yyyy-mm-dd")).*"T".*t) # Combine Date and Time
    q = t.=="00:00"
    M[:DateTime] .+= Day.(q)
    rename!(M,[:BAR => :P;
               :Wind => :WindSpeed
               ])
    M
end

end # module
