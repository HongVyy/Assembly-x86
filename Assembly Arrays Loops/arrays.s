.data
my_array: .space 300        # allocate 20 bytes to hold 5 4-byte integers ....
newline:  .asciiz   "\n\t"
onespace: .asciiz   " "
.text
.globl main
.ent main
main:
       li $s0, 60            # $s0 holds the size of the array
       la $s1, my_array      # load base address of array into $s1
       addi $t0, $zero, 0    # initialize i to 0
top:
       slt $t1, $t0, $s0         # set on less than
                                 # t1 = (i < size) ? 1 : 0;
       beq $t1, $zero, secline   # Exit if i >= size
       addi $t1, $t0, 1      # Add 5 to i, store in t1
       sll $t2, $t0, 2       # shift left logical.
                             # Calculate i*4, store in t2
       add $t2, $t2, $s1     # Calculate address of a[i]
       sw $t1, 0($t2)        # Store t1 to element address
       addi $t0, $t0, 2      # Increment i

       li $v0, 1             # print the element you just stored in the array 
       lw $a0, 0($t2)        # load int value from the array into a register
       syscall

       li $v0, 4
       la $a0,onespace 
       syscall

       j top                 # Go to next iteration

secline: 
       li $v0, 11
       li $a0, 10
       syscall

       li $s0, 60
       la $s1, my_array
       addi $t0, $zero, 0

sectop: 
       slt $t1, $t0, $s0
       beq $t1, $zero, Exit

       sll $t2, $t0, 2
       add $t2, $t2, $s1
       lw $t1, 0($t2)

       addi $t0, $t0, 1
       addi $t3, $zero, 3
       addi $t4, $zero, 7

       beq $t1, $zero, sectop
       div $t1, $t3

       mfhi $t5
       beq $t5, $zero, print
       div $t1, $t4

       mfhi $t6
       beq $t6, $zero, print
       j sectop

print: 
       lw $a0, 0($t2)
       li $v0, 1
       syscall

       li $v0, 4
       la $a0, onespace
       syscall

       j sectop
Exit:
       li $v0, 4             # display a newline
       la $a0, newline
       syscall

       li $v0, 10            # exit
       li $a0, 0
       syscall

.end main

