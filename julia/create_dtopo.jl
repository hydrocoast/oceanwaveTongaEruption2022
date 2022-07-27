using VisClaw
using Printf

dx = dy = 0.25
x = collect(Float64, 184.0:dx:185.0)
#y = collect(Float64, -21.0:dy:-20)
y = collect(Float64, 39.0:dy:40)
ny = length(y)
nx = length(x)
deform = ones(ny,nx)

dtopo = VisClaw.DTopo(nx,ny,x,y,dx,dy,1,1.0,10.0,deform)


VisClaw.printdtopo(dtopo,"test_dtopo.asc")


