# rtrim.s 
 
    .data
input: .space 100
input2: .space 100
astring: .asciiz "Enter a word with some whitespace: "   
dot: .asciiz "."
newline: .asciiz "\n"

    .text
.globl main             
main:
    # test if cmd line arg was passed
    li $v0, 4
    la $a0, astring
    syscall

    li $v0, 8               # Read input string into $a0
    la $a0, input
    li $a1, 100
    syscall

    li $t0, 0               # initialize counter to 0
remove: 
    
    lb $t1, input($t0)          # Load a byte from string into $t1
 
    beq $t1, 32, done       # if byte is a space (32) branch to done
    beq $t1, 9, done        # if byte is a tab (9) branch to done
    
    sb $t1, input2($t0)     # store byte in string 2
    addi $t0, $t0, 1        # counter

    j remove                # Jump to remove white space remove

done:
    sb $0, input2($t0)      #Add null terrminator to input2
    la $a0, input2          #Print input2
    li $v0, 4
    syscall
    
    la $a0, dot             #Print "."
    li $v0, 4
    syscall
 
    la $a0, newline         #Print a new line
    li $v0, 4
    syscall 
   
    li $v0, 10              #Exit program
    syscall
