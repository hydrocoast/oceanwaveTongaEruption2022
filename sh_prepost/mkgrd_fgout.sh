#!/bin/bash

if [ $# -lt 1 ]; then
   echo "Invalid number of argument."
   echo "usage: $0 [fgoutNNNN.qXXXX]" 
   exit 2
fi

#fgfile=_output/fgout0001.q0271
fgfile="$1"

if [ ! -e "$fgfile" ]; then
   echo "Not found: $fgfile"
   exit 2
fi
if [ ! -d "_grd" ]; then mkdir "_grd"; fi


mx=$( awk 'NR==3 {print $1}' $fgfile )
my=$( awk 'NR==4 {print $1}' $fgfile )
xlow=$( awk 'NR==5 {printf "%e", $1}' $fgfile )
ylow=$( awk 'NR==6 {printf "%e", $1}' $fgfile )
dx=$( awk 'NR==7 {printf "%e", $1}' $fgfile )
dy=$( awk 'NR==8 {printf "%e", $1}' $fgfile )

xh=$( echo $xlow $dx $mx | awk '{printf "%e", $1+$2*$3}') 
yh=$( echo $ylow $dy $my | awk '{printf "%e", $1+$2*$3}') 
#echo $yh
#echo $xh


## check i, j, z
#awk -v mx=$mx '{ if (NR>9 && (NR-9)%(mx+1)!=0 ) {printf "%d, %d, %e\n", (NR-9)%(mx+1), (NR-9)/(mx+1)+1, $4}}' $fgfile | tee tmp.log

## check x, y, z
#awk -v mx=$mx -v xlow=$xlow -v ylow=$ylow -v dx=$dx -v dy=$dy '{ \
#if (NR>9 && (NR-9)%(mx+1)!=0 ) \
#{printf "%e, %e, %e\n", xlow + dx*int((NR-9)%(mx+1)-1), ylow + dy*int((NR-9)/(mx+1)), $4} \
#}' $fgfile | tee tmp2.log


## makegrd (x,y,z)
filename_base=`basename $fgfile`
grdfile=${filename_base//\.q/_}".grd"
#echo $grdfile

region="$xlow/$xh/$ylow/$yh"
#echo $region

radius=`echo $dx $dy | awk '{printf "%f", sqrt($1*$1 + $2*$2)}'`
#echo $radius

awk -v mx=$mx -v xlow=$xlow -v ylow=$ylow -v dx=$dx -v dy=$dy '{ \
if (NR>9 && (NR-9)%(mx+1)!=0 ) \
{printf "%e, %e, %e\n", \
	xlow + dx*int((NR-9)%(mx+1)-1) + 0.5*dx, \
	ylow + dy*int((NR-9)/(mx+1)) + 0.5*dy, \
	$4*100} \
}' $fgfile | \
gmt nearneighbor -I$dx/$dy -R$region -G$grdfile -S$radius
#gmt surface -I$dx/$dy -R$region -G$grdfile 

mv $grdfile "_grd/"
