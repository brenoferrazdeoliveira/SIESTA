!=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-!
! created     : 2015/09/02													   !
! last update : 2015/09/09													   !
! author      : Rafael Dexter <dexter.nba@gmail.com>						   !
! notes       :																   !
!=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-! 
program fullteste
    implicit none
    integer :: i=0, j=0, d=0, cont=0
    real(8) :: media=0.0_8, soma=0.0_8, variancia=0.0_8, sigma=0.0_8, desvio=0.0_8
    real, allocatable, dimension(:) :: AE, PT
! Read the dimention wich will be.
open(unit=30,file='DIMENSION',status='old',form='formatted')
read(30, '(i2)') d
close(30)
! Test for allocate vectors
    if (.not. allocated(AE)) then
         allocate(AE(d))
    else
        CALL EXECUTE_COMMAND_LINE("echo '\033[31m ERROR in allocate AE \033[0m.'")
    end if
    if (.not. allocated(PT)) then
         allocate(PT(d))
    else
        CALL EXECUTE_COMMAND_LINE("echo '\033[31m ERROR in allocate PT \033[0m.'")
    end if
! Format used for read vectors.     
22 format (f7.4)
! Open and read vector AE.
open(unit=50,file='AE',status='old',form='formatted')    
read(50, 22) AE
close(50)
! Open and read vector PT.
open(unit=40,file='PT',status='old',form='formatted')
read(40, 22) PT
close(40)
!CALL EXECUTE_COMMAND_LINE("echo '\033[94m MEUS TESTES LOUCOS DE CALCULOS.\033[0m'")
DO i=1, d
    soma = soma + abs(PT(i) - AE(i))
    desvio = desvio + (abs(PT(i) - AE(i)))**2
    cont = cont + 1
END DO
! Clear out memory
DEALLOCATE (PT, AE)
media = soma/cont
variancia = (desvio/cont) - (media**2)
sigma = DSQRT(variancia)
! Verifica qual a classificação do pp's
print*, "The generated pseudopotential is... " 
if (media .LE. 0.000001) then
CALL EXECUTE_COMMAND_LINE("echo '\033[96m PERFECT \033[0m'")
else if (media .LE. 0.00001) then
CALL EXECUTE_COMMAND_LINE("echo '\033[93m GREAT \033[0m'")
else if (media .LE. 0.0001) then
CALL EXECUTE_COMMAND_LINE("echo '\033[92m GOOD \033[0m'")
else if (media .LE. 0.001) then
CALL EXECUTE_COMMAND_LINE("echo '\033[94m  REGULAR \033[0m'")
else
CALL EXECUTE_COMMAND_LINE("echo '\033[31m POOR \033[0m.'")
end if
! Save results in a file
open(unit=60,file='RESULTS',status='new',form='formatted')
write(60,'("Average:",1x,f10.8)') media
write(60,'("Variance:",1x,f10.8)') variancia
write(60,'("Standard deviation:",1x,f10.8)') sigma
close(60)
write(*,'("The average value is:",2x,f10.8)') media
CALL EXECUTE_COMMAND_LINE("echo '\033[96m Results saved in\033[0m RESULTS \033[96mfile\033[0m'")     
end program fullteste
