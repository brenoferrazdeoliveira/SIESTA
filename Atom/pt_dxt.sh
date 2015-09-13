#!/bin/bash -f
#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-#
# created     : 2015/09/02													   #
# last update : 2015/09/09													   #
# author      : Rafael Dexter <dexter.nba@gmail.com>						   #
# notes       :	several_test.sh -- Script to run pseudopotential test 		   # 
# calculations for several exchange-correlation type different				   #
#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-#
# Manual 3.2.8
# The relevant plotting scripts (without .gplot or .gps extensions) are:
# • charge: It compares the AE and PT charge densities.
# • pt: Compares the valence all-electron and pseudo-wavefunctions.
# Funções
vector() {
# Esta função prepara os arquivos para que eles possam ser lidos pelo meu programa
# Pega o ultimo número da matriz
	cat OUT | grep '&d' | cut -d" " -f8- > OUTput 
# Operações com os números da linhas. Estes serão usados posteriormente.
	NUM=$(grep '&d' OUT | tail -n 1 | cut -d" " -f4)
	MUN=$(echo "$NUM-1" | bc ) # $MUN será usado para pegar o as colunas, menos a última
	DUN=$(echo "$NUM*2" | bc ) # Dobro de $NUM, ou seja número da linha que começa o PT
	MAI=$(echo "$NUM+2" | bc ) # Começa na linha que me interessa para o PT
# Transformar 'OUTput' em 2 arquivos
	for I in $(seq 1 $MUN); do
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
#
# Idem, mas para o PT # vote 13
#
	for J in $(seq $MAI $DUN) ; do # J -> linha
		for K in $(seq 1 $MUN) ; do # K -> coluna
		(cat OUTput | head -n $J | tail -n 1 | awk -v A=$K '{ print $A }') >> PT2
		#echo "$TEXTO" # controle do for
		done
	done
#
# Remover as linhas em branco
#
	sed '/^$/d' PT2 > PT
	sed '/^$/d' AE2 > AE
#
# Preciso de um arquivo com o numero de linhas do arquivo AE (ou PT) para usar
# de dimensao do vetor para ser usado no Myprog
#
	wc -l AE | cut -d" " -f1 > DIMENSION
#
	rm -f OUTput PT2 AE2
}
plot() {
# Esta função plota os gráficos importantes 'charge' e 'pt'
	cp -f ${UTILS_DIR}/style.plt . 2>> $HERE/ERROR.log
	for i in charge pt ; do
		cp -f ${UTILS_DIR}/$i.plt . 2>> $HERE/ERROR.log
		gnuplot $i.plt
		if [ $? = 0 ]; then # verificação!
			echo "$i.plt plotted" 2>> $HERE/ERROR.log 
		else
			echo "\033[31;1m ERROR: An error occurred to the plotting $i.plt !\033[m"
		exit
		fi
	done
	rm style.plt 2>> $HERE/ERROR.log
}
#
# Função que copia os arquivos de dados importantes
#
dataplot() {
#
for boys in $(seq 0 3); do
	if [ -e  AEWFNR$boys ] && [ -e PTWFNR$boys ]; then
		cp -v AEWFNR$boys $HERE/DADOS/AEWFNR$boys-$name-$IND 2>> $HERE/ERROR.log
		cp -v PTWFNR$boys $HERE/DADOS/PTWFNR$boys-$name-$IND 2>> $HERE/ERROR.log
	fi
done
if [ -e PSCHARGE ] && [ -e PTCHARGE ]; then
		cp -v PSCHARGE $HERE/DADOS/PSCHARG-$psname-$IND 2>> $HERE/ERROR.log
		cp -v PTCHARGE $HERE/DADOS/PSCHARG-$psname-$IND 2>> $HERE/ERROR.log
fi
}
#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-#
# Start # Verificando os parâmetros de entrada
#
if [ "$#" != 4 ]; then
	echo "Usage: \033[38;5;196mfullptatom\033[0m \
\033[38;5;82m<ptname.inp>\033[0m \033[38;5;14m<psname.inp>\033[0m \
\033[38;5;127m<flag>\033[0m \033[38;5;11m(<r>, <s> or <n>)\033[0m"
	echo "<flag>: Job performed by the code: pg or pe."
	echo "		 pg -> Generate pseudopotential without any non-linear core correction;"
	echo "		 pe -> Generate pseudopotential with non-linear partial core correction (core correction exchange)."
	echo "Exchange-correlation type: (<r>, <s> or <n>)."
	echo "		 <r> for relativistic;"
	echo "		 <s> for spin-polarization but nonrelativistic;"
	echo "		 <n> without any correction."
	exit
fi
#
# Testa se as 2 primeiras entradas são arquivos
#
if [ -e $1 ] && [ -e  $2 ]; then
	echo "$1 and $2 are valid files."
	ptfile=$1
	psfile=$2
	ptname=`basename $ptfile .inp`
	psname=`basename $psfile .inp`
else
	echo "\033[31;1m ERROR: One these two files not exist!\033[m" & exit
fi
#
# Testa se a terceira entrada está correta
#
if [ "$3" = "pg" ]; then
		flag='pg' ; echo "$flag -> Generate pseudopotential without any	non-linear core correction."
  elif [ "$3" = "pe" ]; then
  		flag='pe' ; echo "$flag -> Generate pseudopotential with non-linear partial core correction (core correction exchange)."
  else
	echo "\033[31;1m ERROR: This is not a valid character for flavor!\033[m" & exit
fi
# Testa se a quarta entrada está correta
#
if [ "$4" = "r" ]; then
	EXC=$4 ; echo "Exchange-correlation = relativistic."
	# Nome da pasta principal
	name=$psname-$flag-relativistic
elif [ "$4" = "s" ]; then
	EXC=$4 ; echo "Exchange-correlation = spin-polarization."
	# Nome da pasta principal
	name=$psname-$flag-spin
elif [ "$4" = "n" ]; then
	EXC='' ; echo "Whithout exchange-correlation."
	# Nome da pasta principal
	name=$psname-$flag-nonXC
else  
	echo "\033[31;1m ERROR: This is not a valid character for exchange-correlation!\033[m" & exit
fi
#
# END # Verificando os parametros de entrada
#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-#
dialog --stdout --backtitle 'Developed by Rafael Dexter' \
   --title 'Welcome to Atom data analysis'              \
   --msgbox 'Versão teste - test version\ngithub.com/RafaelDexter/SIESTA' 0 0
#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-#
# Start # Verifica a existancia do diretorio onde serao criados todos os testes
#
if [ -d $name ]; then
	clear
	dialog --stdout --backtitle 'Developed by Rafael Dexter' \
   --title 'Warning' \
   --yesno "\nThis directory $name already exists. Do you want override it?" 0 0
		if [ $? = 0 ]; then
			clear
			rm -r $name
			if [ -d 'DADOS' ]; then rm -fv DADOS 2>> $HERE/ERROR.log ; fi
			echo "$name directory deleted."
			sleep 1
		else
			clear
			echo "The program can't precede."
			exit
		fi
fi
#
# END # Verifica a existancia do diretorio onde serao criados todos os testes
#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-#
# Start # Caminhos
#
UTILS_DIR="/home/dxt/Github/SIESTA/Atom"
prog="/home/siesta/atm"
Myprog="/home/dxt/Github/SIESTA/Atom/fullteste.exe" # Neste caso!
HERE=$(pwd)
#
# END # Caminhos
#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-#
# Cria uma pasta para onde será copiado os dados importantes
mkdir $HERE/DADOS
# Cria um diretori onde ira conter todos os resultados dos testes
mkdir $HERE/$name ; cd $HERE/$name
#
#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-#
# Start # Flag  # PWD = $HERE/$name
cat "$HERE/$psfile" | sed "s/PP/"$flag"/" > PPT
#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-#
# Start # Flavors LDA
mkdir LDA ; cd LDA
				# PWD = $HERE/$name/LDA
for IND in ca$EXC wi$EXC hl$EXC gl$EXC bh$EXC ; do
	mkdir $IND ; cd $IND
#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-#
# 1º Gerar o pseudopotencial com exchange-correlation dada por $IND
#				# PWD = $HERE/$name/LDA/$IND
	cat "$HERE/$name/PPT" | sed "s/dxt/"$IND"/" > INP
	$prog
	if [ $? = 0 ]
	then
	echo "Output data for pseudopotential generation with job performed by $flag and \
exchange correlation $IND are in directory:"
	echo "$HERE/$name/LDA/$IND"
	else
		echo "\033[31;1m ERROR: An error occurred pseudopotential generation $IND.\033[m"
		exit
	fi
	mv VPSOUT VPSIN
	mv INP INP-PSGTOR
#
# Testa se o arquivo INP foi realmente apagado
#
	if [ -e 'INP' ]; then
		echo "\033[31;1m ERROR: INP file has been NOT renamed!\033[m" & exit
	else
		echo "############################################"
		echo "# INP file has been renamed for INP-PSGTOR #"
		echo "############################################"
		echo " "
	fi
# 1º END
#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-#
# 2º  Preparar os arquivos para leitura no ATOM para teste
				# PWD = $HERE/$name/LDA/$IND
	cat "$HERE/$ptfile" | sed "s/dxt/"$IND"/" > INP	

# 2º END  
#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-#
# 3º # Execuçao do ATOM
				# PWD = $HERE/$name/LDA/$IND
	$prog
	if [ $? = 0 ]
	then
	echo "Output data for pseudopotential tests with job performed by $flag and \
exchange correlation $IND are in directory:"
	echo "$HERE/$name/LDA/$IND"
	else
		echo "\033[31;1m ERROR: An error occurred in test of the pseudopotential $IND.\033[m"
		exit
	fi
# 3º END

#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-#
# Start # Execuçao do Meu programa para análise dos dados
	vector
	$Myprog
	if [ $? != 0 ]; then
		echo "\033[31;1m ERROR: An error occurred in the analysis $IND.\033[m"
		exit
	fi
	sleep 1
# END # Execuçao do Meu programa para analise dos dados	
#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-#
# start # plots
	plot
	dataplot
# end 	# plots
#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-#
#	Copia o resultado para $HERE
	echo " "
	echo "##############################################"
	echo "# RESULTS salved in $HERE/$psname-$flag-$IND #"
	echo "##############################################"
	echo " "
	cp RESULTS $HERE/$psname-$flag-$IND
	echo " "
	echo " "
	cd ../ # Nao esquecer de voltar uma pasta
done
# END # Flavors LDA
#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-#
#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-#
cd $HERE/$name
#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-#
#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-#
# Start # Flag  # PWD = $HERE/$name
cat "$HERE/$psfile" | sed "s/PP/"$flag"/" > PPT
#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-#
# Start # Flavors GGA
mkdir GGA ; cd GGA
				# PWD = $HERE/$name/LDA
for IND in pb$EXC rp$EXC rv$EXC wc$EXC bl$EXC ps$EXC ; do
	mkdir $IND ; cd $IND
#
#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-#
# 1º Gerar o pseudopotencial com exchange-correlation dada por $IND
#				# PWD = $HERE/$name/GGA/$IND
	cat "$HERE/$name/PPT" | sed "s/dxt/"$IND"/" > INP
	$prog
	if [ $? = 0 ]
	then
	echo "Output data for pseudopotential generation with job performed by $flag and \
exchange correlation $IND are in directory:"
	echo "$HERE/$name/GGA/$IND"
	else
		echo "\033[31;1m ERROR: An error occurred pseudopotential generation $IND.\033[m"
		exit
	fi
	mv VPSOUT VPSIN
	mv INP INP-PSGTOR
#
# Testa se o arquivo INP foi realmente apagado
#
	if [ -e 'INP' ]; then
		echo "\033[31;1m ERROR: INP file has been NOT renamed!\033[m" & exit
	else
		echo "############################################"
		echo "# INP file has been renamed for INP-PSGTOR #"
		echo "############################################"
		echo " "
	fi
# 1º END
#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-#
# 2º  Preparar os arquivos para leitura no ATOM para teste
				# PWD = $HERE/$name/GGA/$IND
	cat "$HERE/$ptfile" | sed "s/dxt/"$IND"/" > INP	

# 2º END  
#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-#
# 3º # Execuçao do ATOM
				# PWD = $HERE/$name/GGA/$IND
	$prog
	if [ $? = 0 ]
	then
	echo "Output data for pseudopotential tests with job performed by $flag and \
exchange correlation $IND are in directory:"
	echo "$HERE/$name/GGA/$IND"
	else
		echo "\033[31;1m ERROR: An error occurred in test of the pseudopotential $IND.\033[m"
		exit
	fi
# 3º END
#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-#
# Start # Execuçao do Meu programa para análise dos dados
	vector
	$Myprog
	if [ $? != 0 ]; then
		echo "\033[31;1m ERROR: An error occurred in the analysis $IND.\033[m"
		exit
	fi
	sleep 1
# END # Execuçao do Meu programa para analise dos dados	
#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-#
# Start # Plots
	plot
	dataplot
	# END	# Plots
#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-#
#	Copia o resultado para $HERE
	echo " "
	echo "##############################################"
	echo "# RESULTS salved in $HERE/$psname-$flag-$IND #"
	echo "##############################################"
	echo " "
	cp RESULTS $HERE/$psname-$flag-$IND
	echo " "
	echo " "
	cd ../ # Nao esquecer de voltar uma pasta
done
# END # Flavors GGA
##=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-#
echo '==> FIM == END == ZeFini <=='
