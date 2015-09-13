#-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-==-=-=-#
# created     : 2015/08/12												       #
# last update : 2015/08/12												       #
# author      : Rafael Dexter <dexter.nba@gmail.com>			       		   #
# notes       : GNUPlot 5.0.1												   #
#-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-==-=-=-#
# Expects to be passed the L value as a quoted parameter (@ARG1)
#
#set style data lines
#
set multiplot
set size 0.5,0.5
#
set origin 0.0,0.0
set key at graph 0.9, 0.3 Left reverse samplen 1 spacing 1.2 width -2
plot [0:4] sprintf("PSPOTR%d",@ARG1) using 1:2 title sprintf("l=%d - Pseudopot r",@ARG1)  with lines,\
0.0 notitle with lines ls 3

##### goes offscale...  'PSPOTR@ARG1' using 1:3 notitle  with linespoints

set origin 0.5,0.0
set key at graph 0.9, 0.3 Left reverse samplen 1 spacing 1.2 width -2
plot [0:20] sprintf("PSPOTQ%d",@ARG1) using 1:2 title sprintf("l = %d - Pseudopot q",@ARG1)  with lines,\
0.0 notitle with lines ls 3 
#
set origin 0.0,0.5
set key at graph 0.9, 0.5 Left reverse samplen 1 spacing 1.2 width -2
plot [0:4] sprintf("AEWFNR%d",@ARG1) using 1:2 with lines ls 1 title sprintf("AE wfn l=%d",@ARG1), \
	sprintf("PSWFNR%d",@ARG1) using 1:2 with lines ls 2 title sprintf("PS wfn l=%d",@ARG1), \
	0.0 notitle with lines ls 3
#
set origin 0.5,0.5
#
# Logarithmic derivative
#
#set key right center vertical Left reverse samplen 1 spacing 1.2 width -2 # 1 height 0.5 nobox
set key at graph 0.9, 0.5 Left reverse samplen 1 spacing 1.2 width -2
there_is_logd=`test -f AELOGD@ARG1 && echo 1 || echo 0`
if (there_is_logd == 1) \
plot sprintf("AELOGD%d",@ARG1) us 1:2 with lines ls 1 ti sprintf("AE logder l=%d",@ARG1), \
	sprintf("PSLOGD%d",@ARG1) us 1:2 with lines ls 2 ti sprintf("PS logder l=%d",@ARG1)
#
set nomultiplot
#unset output
