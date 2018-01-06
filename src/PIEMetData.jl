module PIEMetData

using DataFrames, CSV, Base.Dates

export parsemet, setmetdatadir!

met_data_directory = Dict(:_METDATA_DIR=>"")

function setmetdatadir!(path,datavars=met_data_directory)
    datavars[:_METDATA_DIR] = path
end

doy(t::DateTime) = dayofyear(t) + (hour(t)+minute(t)/60)/24

function doy2date(y,d)
    md = [Base.Dates.MONTHDAYS...;365]
    ms = 1:13
    if isleapyear(y)
        md[ms.>2]+=1
    end
    m = findfirst(x->x>=d,md)-1
    if m <= 0
        error("$d is not a valid day of the year")
    end
    dd = d-md[m]
    Date(y,m,dd)    
end

function timepad(ds)
    map(x->lpad(string(x),4,'0'),ds)
end

const metdatatypes = [Int, # Year
                      Int, # Code
                      Int, # Day
                      Int, # Time
                      Float64, # R
                      Float64, # Rad
                      Float64, #PAR
                      Float64, #T
                      Float64, #RH
                      Float64, #WindSpeed
                      Float64, #WindDir
                      Float64, #P
                      Float64, #AvgRain
                      Float64, # Pyru
                      Float64  # MaxWindSpeed
                      ]
 
function parsemet(year::Int,metdatadir=met_data_directory[:_METDATA_DIR])
    ys = parse.(readdir(metdatadir))
    in(year,ys) || error("met data requested for unavailable year: $year")
    M = CSV.read(joinpath(metdatadir,string(year),"met.csv"),types=metdatatypes)
    n = size(M,1)
    M[:Date] = map(x->doy2date(M[x,:Year],M[x,:Day]),1:n)
    mstring = String[string(x) for x in M[:Date]]
    tstring = String[timepad(x) for x in M[:Time]]
    # The PIE met data uses 2400 on day i instead of 0000 on
    # day i+1
    q = tstring .== "2400"
    tstring[q] = "0000"
    M[:DateTime] = DateTime(mstring.*tstring,
                            DateFormat("yyyy-mm-ddHHMM"))+Day.(q)
    M
end

end # module
