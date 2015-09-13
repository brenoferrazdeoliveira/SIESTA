#-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-==-=-=-#
# created     : 2015/08/12												       #
# last update : 2015/08/12												       #
# author      : Rafael Dexter <dexter.nba@gmail.com>			       		   #
# notes       : GNUPlot 5.0.1												   #
#-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-==-=-=-#
set terminal pdfcairo enhanced color font "Times, 8" fontscale 0.4 background "#C0C0C0" size 8.4cm, 5.94cm
set output "pots.pdf"
#
there_is_s=`test -f PSPOTR0 && echo 1 || echo 0`
there_is_p=`test -f PSPOTR1 && echo 1 || echo 0`
there_is_d=`test -f PSPOTR2 && echo 1 || echo 0`
there_is_f=`test -f PSPOTR3 && echo 1 || echo 0`
#
set style data lines
if (there_is_s == 0) print "No s pseudo... quiting..." ; quit
#
plot [0:4]  'PSPOTR0' title "V_s"
if (there_is_p == 1) replot  'PSPOTR1' title "V_p" 
if (there_is_d == 1) replot  'PSPOTR2' title "V_d" 
if (there_is_f == 1) replot  'PSPOTR3' title "V_f" 
#
quit
#
