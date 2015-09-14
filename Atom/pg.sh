#!/bin/bash -f
#
# pg.sh -- Script to run pseudopotential generation calculations
#
# Usage: pgatom <name.inp>
#
if [ "$#" != 1 ] 
then
	echo "Usage: pgatom <name.inp>"
	exit
fi
#
file=$1
name=`basename $1 .inp`
#
if [ -d $name ]; then
	clear
	dialog --stdout --backtitle 'Developed by Rafael Dexter' \
   --title 'Warning' \
   --yesno "\nThis directory $name already exists. Do you want override it?" 0 0
		if [ $? = 0 ]; then
			clear
			rm -r $name
			echo "$name directory deleted."
		else
			clear
			echo "The program can't precede."
			exit
		fi
fi
# Caminhos & definições
default='sh erro.sh'
caminho=${UTILS_DIR:-$default}
prog=${ATOM_PROGRAM:-$default}
#Myprog="/home/dxt/Github/SIESTA/Atom/testes"
#
mkdir $name ; cd $name
cp ../$file ./INP
#
$prog
if [ $? = 0 ]; then
	echo "Output data for pseudopotential generation are in directory: $name"
	else
		echo "\033[31;1m ERROR: An error occurred pseudopotential generation.\033[m"
		exit
	fi
#
cp VPSOUT ../$name.vps
cp VPSFMT ../$name.psf
[ -r VPSXML ] && cp VPSXML ../$name.xml
#
#  Copy plotting scripts
#
for i in style charge vcharge vspin coreq pots pseudo scrpots subps ; do
	cp -f ${caminho}/$i.plt .
done
#
dialog --stdout --backtitle 'Developed by Rafael Dexter' \
   --title 'Warning' \
   --yesno '\n Do you want plot all graphics?' 0 0
		if [ $? = 0 ]; then
			#Ploting
			for j in charge vcharge vspin pots pseudo scrpots ; do
				gnuplot $j.plt
				if [ $? = 0 ]; then
					echo "$j.plt plotted"
				else
					echo "\033[31;1m ERROR: An error occurred to the plotting $j.plt !\033[m"
					exit
				fi
			done
			if [ -f "COREQ" ]; then gnuplot coreq.plt; fi
			pdftk *.pdf cat output graphics.pdf
			evince graphics.pdf &
		else
			clear
		fi
#
echo "Thankyou for use my script."
echo "==> Output data in directory $name"
echo "==> Pseudopotential in $name.vps and $name.psf (and maybe in $name.xml)"
# FIM
