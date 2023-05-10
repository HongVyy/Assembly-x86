.data
newline: .asciiz "\n"
onespace: .asciiz " "
.text
.globl main
main:
    li $t0, 0           # width i
    li $t2, 0           # height j
       
inner:                  # top of inner loop                          
    slti $t1, $t0, 8
    beq  $t1, $zero, innerexit
    beq $t0, $t2, dot

    li $v0, 11                                
    li $a0, '@'                                           
    syscall 

    li $v0, 4
    la $a0, onespace
    syscall

    addiu $t0, $t0, 1
    j inner
                                                              
dot: 
    li $v0, 11
    la $a0, '.'
    syscall
    
    addi $t0, $t0,1
    j inner

innerexit:
    slti $t3, $t2, 7
    beq $t3, $zero, exit
    li $v0, 4             # display a newline
    la $a0, newline
    syscall
    addiu $t2, $t2, 1
    add $t0, $zero, $zero
    j inner
exit: 
    li $v0, 4
    la $a0, newline
    syscall

    li $v0, 10
    syscall

    
