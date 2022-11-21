## check
outdir="_output"
jld2dir="_jld2"
plotdir="_plots"
isdir(outdir) || error("Directory $outdir not found")
isdir(plotdir) || (mkdir(plotdir))


try using GMT:GMT catch ex using GMT:GMT end # to avoid library reference error
## import package
print("import packages ...   ")
ENV["GKSwstype"]="nul"
using Printf
using Dates
using Pkg
Pkg.dir("VisClaw") == nothing && (Pkg.add("VisClaw"))
Pkg.dir("JLD2") == nothing && (Pkg.add("JLD2"))
Pkg.dir("Plots") == nothing && (Pkg.add("Plots"))
using VisClaw
using JLD2
using Plots
gr()
print("end\n")


## set t0 time
#t0_datetime = DateTime(2022,01,15,13,0,0)

## load surface
print("loading eta ...     ")
if isfile(joinpath(jld2dir, "amrall.jld2"))
    @load joinpath(jld2dir, "amrall.jld2") amrall
else
    amrall = loadsurface(outdir)
end
coarsegridmask!(amrall)
tstr = map(t -> @sprintf("%02d h %02d min", floor(t/3600), floor(t/60)-60*floor(t/3600)), amrall.timelap)
replaceunit!(amrall, :hour)
#converttodatetime!(amrall, t0_datetime)
#tstr = Dates.format.(amrall.timelap, "yyyy/mm/dd HH:MM")
print("end\n")


## load region
print("loading region ...     ")
if isfile(joinpath(jld2dir, "regions.jld2"))
    @load joinpath(jld2dir, "regions.jld2") regions
else
    regions = regiondata(outdir)
end
print("end\n")


## load gauges
print("loading gauges ...     ")
if isfile(joinpath(jld2dir, "gauges.jld2"))
    @load joinpath(jld2dir, "gauges.jld2") gauges
else
    gauges = loadgauge(outdir)
end
#converttodatetime!.(gauges, t0_datetime)
replaceunit!.(gauges, :hour)
print("end\n")


## plot eta
print("plotting eta ...     ")
ind_time = 31:amrall.nstep

## around Japan
for i = 3:3
    local plts = plotsamr(amrall, ind_time; clims=(-0.10,0.10), c=:bwr, colorbar=true, region=regions[i])
    local plts = map((p,s)->plot!(p; title=s), plts, tstr[ind_time])
    map((p,k)->savefig(p, joinpath(plotdir,@sprintf("region_%d_surf_%03d.png",i,k))), plts, ind_time)
end
## around specific regions
for i = [4,6]
    local plts = plotsamr(amrall, ind_time; clims=(-0.10,0.10), c=:bwr, colorbar=true, region=regions[i])
    local plts = map((p,s)->plot!(p; title=s), plts, tstr[ind_time])
    local plts = map(p->plotsgaugelocation!(p, gauges[1]; marker=(:magenta, 0.5, Plots.stroke(2, :black))), plts)
    map((p,k)->savefig(p, joinpath(plotdir,@sprintf("region_%d_surf_%03d.png",i,k))), plts, ind_time)
end

