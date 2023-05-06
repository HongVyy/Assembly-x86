#sum.s
#Name: Vo Hong Vy Le ID: 201134354
    .data
stuff: .asciiz " The sum is "
stuff1: .asciiz " and "
stuff2: .asciiz " is "
num1: .word 13
num2: .word 16
dot: .byte 46
lf: .byte 10

    .text
main: 
    la $a0, stuff
    li $v0, 4
    syscall

    lb $t0, num1
    move $a0, $t0
    li $v0, 1
    syscall

    la $a0, stuff1
    li $v0, 4
    syscall

    lb $t1, num2
    move $a0, $t1
    li $v0, 1
    syscall

    la $a0, stuff2
    li $v0, 4
    syscall

    lb $t0, num1
    lb $t1, num2
    addu $a0, $t0, $t1
    li $v0, 1
    syscall

    lb $a0, lf
    li $v0, 11

    li $v0, 10
    syscall
