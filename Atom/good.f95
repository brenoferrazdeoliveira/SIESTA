!=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-!
! created     : 2015/08/28													   !
! last update : 2015/08/28													   !
! author      : Rafael Dexter <dexter.nba@gmail.com>						   !
! notes       :																   !
!=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-!  
program good
    implicit none
    integer :: i=0, j=0, d=0, cont=0
    real(8) :: desvio=0.0_8, soma=0.0_8, variancia=0.0_8, sigma=0.0_8, media=0.0_8
    real, allocatable, dimension(:) :: AE, PT, RE
! Show value of variables, this has been zero
11 format(f4.2,2x,f4.2,2x,f4.2,2x,f4.2,2x,f4.2)
CALL EXECUTE_COMMAND_LINE("echo '\033[96m Just for tests.\033[0m'")
CALL EXECUTE_COMMAND_LINE("echo '\033[96m If appear only zeros (5x) it is every ok:\033[0m'")
write(*,11) desvio, soma, media, variancia, sigma
CALL EXECUTE_COMMAND_LINE("echo '\033[96m If appear only zeros (4x) it is every ok:\033[0m'")
write(*,'(i1,2x,i1,2x,i1,2x,i1)') i, j, d, cont
! ?
CALL EXECUTE_COMMAND_LINE("echo '\033[96m Just for information.\033[0m'")
12 format ('The parameter for average. Precision:',1x,i2,2x,'Range:',1x,i3)
13 format ('The parameter for root-mean-square. Precision:',1x,i2,2x,'Range:',1x,i3)
write(*,12) precision(media), range(media)
write(*,13) precision(sigma), range(sigma)
! Read the dimention wich will be.
open(unit=30,file='DIMENSION',status='old',form='formatted')
read(30, '(i2)') d
close(30)
write(*,'("The dimension of vector is:",1x,i2)'), d
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
     if (.not. allocated(RE)) then
         allocate(RE(d))
    else
        CALL EXECUTE_COMMAND_LINE("echo '\033[31m ERROR in allocate RE \033[0m.'")
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
! Calculus direct
RE = abs(PT - AE)
! ------------- Calculos
CALL EXECUTE_COMMAND_LINE("echo '\033[94m Statistics \033[0m'")
DO i=1, d
    soma = soma + abs(PT(i) - AE(i))
    desvio = desvio + (abs(PT(i) - AE(i)))**2
    cont = cont + 1
END DO
media = soma/cont
variancia = (desvio/cont) - (media**2)
sigma = DSQRT(variancia)
write(*,'("Verify yourself:",1x,i2,1x,"¿=?",1x,i2)') d, cont
write(*,'("Average:",3x,f10.8)') media
write(*,'("Variance:",2x,f10.8)') variancia
write(*,'("Standard deviation:",6x,f10.8)') sigma
!-------------------------------------------------------
CALL EXECUTE_COMMAND_LINE("echo '\033[96m Just for tests of reading of files.\033[0m'")
write(*,'(a)')"#    AE    #    PT    #   AE-PT  #"
33 format ('#',1x,f7.4,2x,'#',1x,f7.4,2x,'#',1x,f7.4,2x,'#')
DO i=1,d
    write(*,33) AE(i), PT(i), RE(i)
END DO
! Save results in a file
    open(unit=60,file='RESULTS',status='new',form='formatted')
    write(60,'("Average:",6x,f10.8)') media
    write(60,'("Variance:",2x,f10.8)') variancia
    write(60,'("Standard deviation:",6x,f10.8)') sigma
    close(60)
    CALL EXECUTE_COMMAND_LINE("echo '\033[96m Results saved in\033[0m RES \033[96mfile\033[0m'")
print*, " "
write (*,'(a)') "In the scale of:" 
CALL EXECUTE_COMMAND_LINE("echo '\033[96m PERFECT\033[0m'")
CALL EXECUTE_COMMAND_LINE("echo '\033[93m GREAT\033[0m'")
CALL EXECUTE_COMMAND_LINE("echo '\033[92m GOOD\033[0m'")
CALL EXECUTE_COMMAND_LINE("echo '\033[94m REGULAR\033[0m'")
CALL EXECUTE_COMMAND_LINE("echo '\033[31m POOR\033[0m'")
print*, " "
print*, "The generated pseudopotential is... " 
if (media .LE. 0.000001) then
CALL EXECUTE_COMMAND_LINE("echo '\033[96m ..::*** PERFECT ***::.. \033[0m'")
else if (media .LE. 0.00001) then
CALL EXECUTE_COMMAND_LINE("echo '\033[93m ..::# GREAT #::..\033[0m'")
else if (media .LE. 0.0001) then
CALL EXECUTE_COMMAND_LINE("echo '\033[92m ..:: GOOD ::..\033[0m'")
else if (media .LE. 0.001) then
CALL EXECUTE_COMMAND_LINE("echo '\033[94m  REGULAR \033[0m'")
else
CALL EXECUTE_COMMAND_LINE("echo '\033[31m !!!!! POOR !!!!!  \033[0m'")
end if
!
!
!
!      
end program good
