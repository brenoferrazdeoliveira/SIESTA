#-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-==-=-=-#
# created     : 2015/08/12												       #
# last update : 2015/08/12												       #
# author      : Rafael Dexter <dexter.nba@gmail.com>			       		   #
# notes       : GNUPlot 5.0.1												   #
#-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-==-=-=-#
set terminal pdfcairo enhanced color font "Times, 8" fontscale 0.4 background "#C0C0C0" size 8.4cm, 5.94cm
set output "coreq.pdf"
#
there_is_core=`test -f COREQ && echo 1 || echo 0`
#
if (there_is_core==0) {
quit
}
#
plot [0:20] 'COREQ' using 1:2 title "Core Charge (q)" with lines, \
0.0 notitle with lines lt 0
#    
#
print "==> PDF output in coreq.pdf | by: Dexter :D "
#
