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


### load topo
#print("loading topo ...     ")
#if isfile(joinpath(jld2dir, "topo.jld2"))
#    @load joinpath(jld2dir, "topo.jld2") topo
#else
#    topo = loadtopo(outdir)
#end
#print("end\n")
#
### plot topo
#print("plotting topo ...     ")
#if isa(topo, Array)
#    plt = plotstopo(topo[1]; c=:lapaz, clims=(-Inf,1e-3))
#    plt = plotscoastline!(plt, topo[1]; lc=:black)
#    plt = last(map(t->plotstoporange!(plt,t), topo[2:end]))
#else
#    plt = plotstopo(topo; c=:lapaz, clims=(-Inf,1e-3))
#    plt = plotscoastline!(plt, topo; lc=:black)
#end
#savefig(plt, joinpath(plotdir,"topo.svg"))
#print("end\n")


## load surface
print("loading eta ...     ")
if isfile(joinpath(jld2dir, "amrall.jld2"))
    @load joinpath(jld2dir, "amrall.jld2") amrall
else
    amrall = loadsurface(outdir)
end
coarsegridmask!(amrall)
tstr = map(t->@sprintf("%02d h %02d min", floor(t/3600), floor(t/60)-60*floor(t/3600)), amrall.timelap)
replaceunit!(amrall, :hour)
#converttodatetime!(amrall, t0_datetime)
#tstr = Dates.format.(amrall.timelap, "yyyy/mm/dd HH:MM")
print("end\n")


## plot eta
print("plotting eta ...     ")
plts = plotsamr(amrall; clims=(-0.10,0.10), c=:bwr, colorbar=true)
plts = map((p,s)->plot!(p; title=s), plts, tstr)
map((p,k)->savefig(p, joinpath(plotdir,"surf_"*@sprintf("%03d",k)*".png")), plts, 1:amrall.nstep)
print("end\n")


## load gauges
print("loading gauges ...     ")
if isfile(joinpath(jld2dir, "gauges.jld2"))
    @load joinpath(jld2dir, "gauges.jld2") gauges
else
    gauges = loadgauge(outdir)
end
replaceunit!.(gauges, :hour)
#converttodatetime!.(gauges, t0_datetime)
print("end\n")


## plot gauges
if !isempty(gauges)
    print("plotting gauges ...     ")
    for g in gauges
        local plt = plotsgaugewaveform(g; title=g.label, label=false, ylims=(-0.5,1.0), xlims=(6.0,16.5))
        #tg = g.time[1]:Hour(1):g.time[end]
	#local plt = plotsgaugewaveform(g; title=g.label, label=false, ylims=(-0.5,1.0),
	#			       xticks=(tg,Dates.format.(tg,"HH:MM")), xrot=45)
        savefig(plt, joinpath(plotdir,"gauge_"*@sprintf("%04d",g.id)*".png"))
    end
    print("end\n")
end


## load fgmax
print("loading fgmax ...     ")
if isfile(joinpath(jld2dir, "fgmax.jld2"))
    @load joinpath(jld2dir, "fgmax.jld2") fg fgmax
else
    fg = fgmaxdata(outdir)
    if !isempty(fg)
        fgmax = loadfgmax.(outdir, fg)
    end
end
print("end\n")


## plot fgmax
if !isempty(fg)
    print("plotting fgmax ...     ")
    #converttodatetime!.(fgmax, t0_datetime)
    replaceunit!.(fgmax, :hour)
    nfg = length(fg)
    for k = 1:nfg
        ## dep
        local plt = plotsfgmax(fg[k], fgmax[k], :D; clims=(-1e-5,0.5), c=cgrad(:jet, 10, categorical = true))
        savefig(plt, joinpath(plotdir, @sprintf("fgmax_%03d.svg",k)))
        local plt = plotsfgmax(fg[k], fgmax[k], :tD; c=cgrad(:phase, 12, categorical = true))
        savefig(plt, joinpath(plotdir, @sprintf("fgmax_maxtime_%03d.svg",k)))
        ## arrival
        local plt = plotsfgmax(fg[k], fgmax[k], :tarrival; c=cgrad(:phase, 12, categorical = true))
        savefig(plt, joinpath(plotdir, @sprintf("fgmax_arrivaltime_%03d.svg",k)))
        ## maxvel
        if fg[k].nval > 1
            local plt = plotsfgmax(fg[k], fgmax[k], :v; clims=(-1e-5,0.5), c=cgrad(:jet, 10, categorical = true))
            savefig(plt, joinpath(plotdir, @sprintf("fgmax_vel_%03d.svg",k)))
            local plt = plotsfgmax(fg[k], fgmax[k], :tv; c=cgrad(:phase, 12, categorical = true))
            savefig(plt, joinpath(plotdir, @sprintf("fgmax_velmaxtime_%03d.svg",k)))
        end
    end
    print("end\n")
end


