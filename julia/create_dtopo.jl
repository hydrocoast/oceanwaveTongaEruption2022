using VisClaw
using Printf

dx = dy = 0.01
x = collect(Float64, 184.59:dx:184.63)
y = collect(Float64, -20.56:dy:-20.53)
#y = collect(Float64, 0.00:dy:0.03)
ny = length(y)
nx = length(x)
deform = 1000.0*ones(ny,nx)

dtopo = VisClaw.DTopo(nx,ny,x,y,dx,dy,1,1.0,10.0,deform)


VisClaw.printdtopo(dtopo,"test_dtopo.asc")


