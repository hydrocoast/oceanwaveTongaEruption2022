## check
outdir="_output"
jld2dir="_jld2"
isdir(outdir) || error("Directory $outdir not found")
isdir(jld2dir) || (mkdir(jld2dir))

try using GMT:GMT catch ex using GMT:GMT end # to avoid library reference error
## import package
print("import packages ...   ")
using Printf
using Pkg
Pkg.dir("VisClaw") == nothing && (Pkg.add("VisClaw"))
Pkg.dir("JLD2") == nothing && (Pkg.add("JLD2"))
Pkg.dir("CSV") == nothing && (Pkg.add("CSV"))
using VisClaw
using JLD2
#using CSV: CSV
print("end\n")


### topo
#print("loading topo ...     ")
#topo = loadtopo(outdir)
#print("end\n")
#
#print("saving topo ...     ")
#@save joinpath(jld2dir, "topo.jld2") topo
#print("end\n")


## track
print("loading track ...     ")
track = loadtrack(outdir)
print("end\n")

print("saving track ...     ")
@save joinpath(jld2dir, "track.jld2") track
print("end\n")


## region
print("loading region ...     ")
regions = regiondata(outdir)
print("end\n")

print("saving region ...     ")
@save joinpath(jld2dir, "regions.jld2") regions
print("end\n")


## surface
print("loading eta ...     ")
amrall = loadsurface(outdir)
coarsegridmask!(amrall)
print("end\n")

print("saving eta ...     ")
@save joinpath(jld2dir, "amrall.jld2") amrall
print("end\n")


## gauges
print("loading gauge ...     ")
gauges = loadgauge(outdir)
print("end\n")

print("saving gauge ...     ")
@save joinpath(jld2dir, "gauges.jld2") gauges
print("end\n")


## fgmax
print("loading fgmax ...     ")
fg = fgmaxdata(outdir)
fgmax = loadfgmax.(outdir, fg)
print("end\n")

print("saving fgmax ...     ")
@save joinpath(jld2dir, "fgmax.jld2") fg fgmax
print("end\n")


## CPU time
#print("loading timing.csv ...     ")
#cputime = CSV.read(joinpath(outdir,"timing.csv"); header=1, datarow=2, delim=',')
#print("end\n")

#print("saving cputime data ...     ")
#@save joinpath(jld2dir, "cputime.jld2") cputime
#print("end\n")
