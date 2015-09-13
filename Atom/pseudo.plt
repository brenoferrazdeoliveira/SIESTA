#-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-==-=-=-#
# created     : 2015/08/12												       #
# last update : 2015/08/12												       #
# author      : Rafael Dexter <dexter.nba@gmail.com>			       		   #
# notes       : GNUPlot 5.0.1												   #
#-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-==-=-=-#
set terminal pdfcairo enhanced color font "Times, 8" fontscale 0.4 background "#C0C0C0" size 8.4cm, 5.94cm
set output "pseudo.pdf"
	##############
	# Style Line #
	##############
#set style data linespoints
	set style line 1 lw 1.1 lc rgb "blue"
	set style line 2 lt rgb "#FF8000" dt 4
	set style line 3 lw 0.01 lc rgb "#202020"
#
#set decimalsign ","
#set termoption dash
#
there_is_s=`test -f PSPOTR0 && echo 1 || echo 0`
there_is_p=`test -f PSPOTR1 && echo 1 || echo 0`
there_is_d=`test -f PSPOTR2 && echo 1 || echo 0`
there_is_f=`test -f PSPOTR3 && echo 1 || echo 0`
#
if (there_is_s == 1) call "subps.plt" 0
if (there_is_p == 1) call "subps.plt" 1
if (there_is_d == 1) call "subps.plt" 2
if (there_is_f == 1) call "subps.plt" 3
#
print "==> Ploted by: Dexter <=="

