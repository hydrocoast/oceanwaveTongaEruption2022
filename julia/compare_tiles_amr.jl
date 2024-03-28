using VisClaw
using GMT: GMT
using Plots
using JLD2

## filenames
simdir1 = "../run_presA_L5_SWJ_v590/_jld2"
simdir2 = "../run_presA_L5_SWJ_v571/_jld2"
jldname = "amrall.jld2"

## load
amrA = JLD2.load(joinpath(simdir1,jldname))["amrall"]
amrB = JLD2.load(joinpath(simdir2,jldname))["amrall"]

level_plot=2:4
tind = 19:20
showlevel=4:4

## Plots
pltsA = plotsamr(amrA,tind; xlims=(125,140), ylims=(15,30), AMRlevel=level_plot, c=:bwr, clims=(-0.2,0.2), colorbar=true)
pltsA = tilebound!.(pltsA, amrA.amr[tind]; AMRlevel=showlevel, lc=:green)
## Plots
pltsB = plotsamr(amrB,tind; xlims=(125,140), ylims=(15,30), AMRlevel=level_plot, c=:bwr, clims=(-0.2,0.2), colorbar=true)
pltsB = tilebound!.(pltsB, amrB.amr[tind]; AMRlevel=showlevel, lc=:green)

