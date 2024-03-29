using VisClaw
using GMT: GMT
using Plots
using JLD2


## filenames
simdir = "../run_presA_L5_SWJ_v590/_jld2"
jldname = "amrall.jld2"

## load
amrall = JLD2.load(joinpath(simdir,jldname))["amrall"]


## Plots
plts = plotsamr(amrall,12:20; xlims=(125,140), ylims=(10,30), AMRlevel=1:5, c=:bwr, clims=(-0.2,0.2), colorbar=true)
plts = tilebound!.(plts, amrall.amr[12:20]; AMRlevel=4:5)
