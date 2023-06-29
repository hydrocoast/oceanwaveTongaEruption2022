## check
matdir = "_mat"
jld2dir="_jld2"
isdir(jld2dir) || error("Directory $jld2dir not found")
isdir(matdir) || (mkdir(matdir))

try using GMT:GMT catch ex using GMT:GMT end # to avoid library reference error
## import package
print("import packages ...   ")
using Printf
using Pkg
Pkg.dir("VisClaw") == nothing && (Pkg.add("VisClaw"))
Pkg.dir("JLD2") == nothing && (Pkg.add("JLD2"))
using VisClaw
using JLD2
using MAT: MAT
print("end\n")

### load fgmax
#print("loading fgmax ...     ")
#@load joinpath(jld2dir, "fgmax.jld2") fg fgmax
#print("end\n")

### convert fgmax
#if !isempty(fg)
#    print("saving fgmax as a matfile ...     ")
#    for k in 1:length(fg)
#        #local file = MAT.matopen(joinpath(jld2dir,@sprintf("fgmax_%03d.mat",k)), "w")
#        local file = MAT.matopen(joinpath(matdir,@sprintf("fgmax_%03d.mat",k)), "w")
#        MAT.write(file, "nx", fg[k].nx)
#        MAT.write(file, "ny", fg[k].ny)
#        MAT.write(file, "xlims", collect(fg[k].xlims))
#        MAT.write(file, "ylims", collect(fg[k].ylims))
#        MAT.write(file, "D", fgmax[k].D)
#        MAT.write(file, "topo", fgmax[k].topo)
#        MAT.write(file, "time_etamax", fgmax[k].tD)
#        MAT.write(file, "time_arrival", fgmax[k].tarrival)
#        # wet cells
#        wet = fgmax[k].D .!= 0.0
#        land = fgmax[k].topo .> 0.0
#        eta = copy(fgmax[k].D)
#        eta[wet] = eta[wet] + fgmax[k].topo[wet]
#        MAT.write(file, "eta", eta)
#        MAT.close(file)
#    end
#    print("end\n")
#end

## load track
if isfile(joinpath(jld2dir, "track.jld2"))
    print("loading track ...     ")
    @load joinpath(jld2dir, "track.jld2") track
    print("end\n")
    
    ## save track
    print("saving fgmax as a matfile ...     ")
    file = MAT.matopen(joinpath(matdir,"track.mat"), "w")
    MAT.write(file, "track", [track.lon track.lat])
    MAT.write(file, "timelap", track.timelap)
    MAT.close(file)
    print("end\n")
end
