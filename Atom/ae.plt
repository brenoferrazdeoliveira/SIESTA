#-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-==-=-=-#
## created     : 2015/08/24												       #
## last update : 2015/08/24												       #
## author      : Rafael Dexter <dexter.nba@gmail.com>			       		   #
## notes       : GNUPlot 5.0.1												   #
##-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-==-=-=-#
set terminal pdfcairo enhanced color font "Times, 8" fontscale 0.4 background "#C0C0C0" size 8.4cm, 5.94cm
set output "ae.pdf"
#
there_is_s=`test -f AEWFNR0 && echo 1 || echo 0`
there_is_p=`test -f AEWFNR1 && echo 1 || echo 0`
there_is_d=`test -f AEWFNR2 && echo 1 || echo 0`
there_is_f=`test -f AEWFNR3 && echo 1 || echo 0`

set style data lines
#
set multiplot
set size 0.5,0.5
#
set origin 0.0,0.5
if (there_is_s == 1 ) \
plot [0:4] 'AEWFNR0' using 1:2 title "AE wfn s" 
set origin 0.5,0.5
if (there_is_p == 1 ) \
plot [0:4] 'AEWFNR1' using 1:2 title "AE wfn p" 
set origin 0.0,0.0
if (there_is_d == 1 ) \
plot [0:4] 'AEWFNR2' using 1:2 title "AE wfn d" 
set origin 0.5,0.0
if (there_is_f == 1 ) \
plot [0:4] 'AEWFNR3' using 1:2 title "AE wfn f" 

set nomultiplot

print "==> PDF output in ae.pdf | by: Dexter :D "








