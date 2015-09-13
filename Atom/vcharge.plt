#-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-==-=-=-#
# created     : 2015/08/12												       #
# last update : 2015/08/12												       #
# author      : Rafael Dexter <dexter.nba@gmail.com>			       		   #
# notes       : GNUPlot 5.0.1												   #
#-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-==-=-=-#
set terminal pdfcairo enhanced color font "Times, 8" fontscale 0.4 background "#C0C0C0" size 8.4cm, 5.94cm
set output "vcharge.pdf"
#
there_is_ps=`test -f PSCHARGE && echo 1 || echo 0`
there_is_pt=`test -f PTCHARGE && echo 1 || echo 0`
#
set style data lines
#
# Note larger range
#
plot [0:5] \
  'AECHARGE' using 1:($2+$3-$4) title "AE valence charge"
#
if (there_is_ps == 1) \
replot   'PSCHARGE' using 1:($2+$3) title "PS valence charge"
#
if (there_is_pt == 1) \
replot 'PTCHARGE' using 1:($2+$3) title "PT valence charge"
#
quit
#
