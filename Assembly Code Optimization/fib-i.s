.data
msg1: .asciiz  " Enter number: "
msg2: .asciiz  " The fibonacci number is: "
.text
.globl main
main: 
li $v0, 4
la $a0, msg1
syscall

li $v0, 5
syscall 

add $a0, $v0, $zero

jal fib
move $t0, $v0

li $v0, 4
la $a0, msg2
syscall

move $v0, $t0 
add $a0, $v0, $zero

li $v0, 1
syscall

li $v0, 10
syscall

fib: 
addi $t0, $zero, 1

beqz $a0, return0
beq $a0, $t0, return1

add $t1, $zero, $zero
add $t2, $zero, $zero

addi $t3, $zero, 1
addi $t4, $zero, 1
loop: 

bge $t4, $a0, endloop
add $t1, $t2, $t3
add $t2, $zero, $t3
add $t3, $zero, $t1
addi $t4, $t4, 1
j loop

endloop:
add $v0, $zero, $t1
jr $ra
return0: 
add $v0, $zero, $zero
jr $ra
return1: 
addi $v0, $zero, 1 
jr $ra
#.....
