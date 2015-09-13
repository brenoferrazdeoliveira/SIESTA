#!/bin/bash -f
#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-#
# created     : 2015/08/14													   #
# last update : 2015/08/14													   #
# author      : Rafael Dexter <dexter.nba@gmail.com>						   #
# notes       :	ae.sh -- Script to run all-electron atomic calculations		   #
#				Usage: ae.sh <name.inp>				                           #
#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-#
if [ "$#" != 1 ] 
then
	echo "Usage: $0 <name.inp>"
	exit
fi
#
file=$1
name=`basename $1 .inp`
#
#
if [ -d $name ]; then
	clear
	dialog --stdout --backtitle 'Developed by Rafael Dexter' \
   --title 'Warning' \
   --yesno '\nThis directory already exists. Do you want override it?' 0 0
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
UTILS_DIR="/home/dxt/Github/SIESTA/Atom"
prog="/home/siesta/atm"
#Myprog="/home/dxt/Github/SIESTA/Atom/testes"
#
mkdir $name ; cd $name
cp ../$file ./INP
#
$prog
#
echo "==> Output data in directory $name"
#
#
#  Copy relevant plotting scripts
#
for i in charge vcharge vspin ae ; do
        cp -f ${UTILS_DIR}/$i.plt .
done
#


