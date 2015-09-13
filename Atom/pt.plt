#-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-==-=-=-#
# created     : 2015/08/12												       #
# last update : 2015/08/12												       #
# author      : Rafael Dexter <dexter.nba@gmail.com>			       		   #
# notes       : GNUPlot 5.0.1												   #
#-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-==-=-=-#
set terminal pdfcairo enhanced color font "Times, 8" fontscale 0.4 background "#C0C0C0" size 8.4cm, 5.94cm
set output "pt.pdf"
#
there_is_s=`test -e AEWFNR0 && PTWFNR0 && echo 1 || echo 0`
there_is_p=`test -e AEWFNR1 && PTWFNR1 && echo 1 || echo 0`
there_is_d=`test -e AEWFNR2 && PTWFNR2 && echo 1 || echo 0`
there_is_f=`test -e AEWFNR3 && PTWFNR3 && echo 1 || echo 0`

set style data lines
#
set multiplot
set size 0.5,0.5
#
set origin 0.0,0.5
if (there_is_s == 1 ) \
plot [0:4] 'AEWFNR0' using 1:2 title "AE wfn s" , \
           'PTWFNR0' using 1:2 title "PT wfn s" 
set origin 0.5,0.5
if (there_is_p == 1 ) \
plot [0:4] 'AEWFNR1' using 1:2 title "AE wfn p" , \
           'PTWFNR1' using 1:2 title "PT wfn p" 
set origin 0.0,0.0
if (there_is_d == 1 ) \
plot [0:4] 'AEWFNR2' using 1:2 title "AE wfn d" , \
           'PTWFNR2' using 1:2 title "PT wfn d" 
set origin 0.5,0.0
if (there_is_f == 1 ) \
plot [0:4] 'AEWFNR3' using 1:2 title "AE wfn f" , \
           'PTWFNR3' using 1:2 title "PT wfn f" 

set nomultiplot
#
quit
