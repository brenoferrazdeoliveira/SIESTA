#!/bin/bash -f
#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-#
# created     : 2015/09/02													   #
# last update : 2015/09/09													   #
# author      : Rafael Dexter <dexter.nba@gmail.com>						   #
# notes       :	pt.sh -- Script to run pseudopotential test calculations	   #
#				Usage: pt.sh <ptname.inp> <psname.vps>                         #
#				Make sure that atm is in path								   #
#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-#
if [ "$#" != 2 ] 
then
	echo "Usage: ptatom <ptname.inp> <psname.vps>"
	exit
fi
#
if [ -f $1 && $2 ] 
then
	echo "This is not a valid file."
	exit
fi
#
file=$1
psfile=$2
ptname=`basename $file .inp`
psname=`basename $psfile .vps`
name="Test-of-$psname"
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
# Caminhos & definições
UTILS_DIR="/home/dxt/Github/SIESTA/Atom"
prog="/home/siesta/atm"
Myprog="/home/dxt/Github/SIESTA/Atom/simples.exe" # Neste caso!
#
mkdir $name ; cd $name
cp ../$file ./INP
cp ../$psfile ./VPSIN
#
$prog
#
#  Copy & plotting scripts
#
clear
dialog --stdout --backtitle 'Developed by Rafael Dexter' \
   --title 'Warning' \
   --yesno '\n Do you want plot all graphics?' 0 0
		if [ $? = 0 ]; then
			clear
			for i in style charge vcharge vspin pt ; do
				cp -f ${UTILS_DIR}/$i.plt .
				gnuplot $i.plt
				if [ $? = 0 ]; then
					echo "$i.plt plotted"
				else
					echo "\033[31;1m ERROR: An error occurred to the plotting $i.plt !\033[m"
					exit
				fi
			done
			if [ -e 'COREQ' ]; then 
				cp -f ${UTILS_DIR}/coreq.plt .
				gnuplot coreq.plt
			fi
			pdftk *.pdf cat output graphics.pdf
			evince graphics.pdf
		else
			clear
		fi
#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-#
# Analysis
cat OUT | grep '&d' | cut -d" " -f8- > OUTput 
NUM=$(grep '&d' OUT | tail -n 1 | cut -d" " -f4)
MUN=$(echo "$NUM-1" | bc )
DUN=$(echo "$NUM*2" | bc )
MAI=$(echo "$NUM+2" | bc )
# Transformar 'OUTput' em 2 arquivos
for I in {1..$MUN} ; do
	(cat OUTput | head -n $NUM | awk -v A=$I '{print $A}') >> AE
	(cat OUTput | tail -n $NUM | awk -v A=$I '{print $A}') >> PT 
done
# Transformar a matriz para o AE em um vetor coluna
for J in $(seq 2 $NUM) ; do # J -> linha
	for K in $(seq 1 $MUN) ; do # K -> coluna
	(cat OUTput | head -n $J | tail -n 1 | awk -v A=$K '{ print $A }') >> AE2
	#echo "$TEXTO" # controle do for
	done
done
# Idem, mas para o PT # vote 13
for J in $(seq $MAI $DUN) ; do # J -> linha
	for K in $(seq 1 $MUN) ; do # K -> coluna
	(cat OUTput | head -n $J | tail -n 1 | awk -v A=$K '{ print $A }') >> PT2
	#echo "$TEXTO" # controle do for
	done
done
# Remover as linhas em branco
#
sed '/^$/d' PT2 > PT
sed '/^$/d' AE2 > AE
# Preciso de um arquivo com o numero de linhas do arquivo AE (ou PT) para usar
# de dimensao do vetor a ser usado no Myprog
wc -l AE | cut -d" " -f1 > DIMENSION
#
rm -f OUTput PT2 AE2
echo "Thankyou for use my script."
echo "==> Output data in directory $name"
echo "Review of pseudopotential $psfile"
# Executar o MEU progama para analise do pseudopotencial
$Myprog
# FIM
