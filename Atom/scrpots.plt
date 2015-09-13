#-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-==-=-=-#
# created     : 2015/08/12												       #
# last update : 2015/08/12												       #
# author      : Rafael Dexter <dexter.nba@gmail.com>			       		   #
# notes       : GNUPlot 5.0.1												   #
#-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-==-=-=-#
set terminal pdfcairo enhanced color font "Times, 8" fontscale 0.4 background "#C0C0C0" size 8.4cm, 5.94cm
set output "scrpots.pdf"
#
#
# Plots bare and screened pseudopotentials
#
there_is_s=`test -f PSPOTR0 && echo 1 || echo 0`
there_is_p=`test -f PSPOTR1 && echo 1 || echo 0`
there_is_d=`test -f PSPOTR2 && echo 1 || echo 0`
there_is_f=`test -f PSPOTR3 && echo 1 || echo 0`

set style data lines
#
set multiplot
set size 0.5,0.5
set origin 0.0,0.5
#
if (there_is_s == 1) \
plot [0:10]  'PSPOTR0'  using 1:2 title "V_s", \
'SCRPSPOTR0'  using 1:2 title "V_s(scr)", \
0.0 notitle   lt 0
#
set origin 0.5,0.5
if (there_is_p == 1) \
plot [0:10]  'PSPOTR1'  using 1:2 title "V_p", \
'SCRPSPOTR1'  using 1:2 title "V_p(scr)", \
0.0 notitle   lt 0
#
set origin 0.0,0.0
if (there_is_d == 1) \
plot [0:10]  'PSPOTR2'  using 1:2 title "V_d", \
'SCRPSPOTR2'  using 1:2 title "V_d(scr)", \
0.0 notitle   lt 0
#
set origin 0.5,0.0
if (there_is_f == 1) \
plot [0:10]  'PSPOTR3'  using 1:2 title "V_f", \
'SCRPSPOTR3'  using 1:2 title "V_f(scr)", \
0.0 notitle   lt 0
set nomultiplot
#
quit
#
