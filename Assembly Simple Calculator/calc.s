.data
newline: .asciiz "\n"
usage_stmt: .asciiz   "\nUsage: spim -f gcd.s <int> <int>\n"
odd: .asciiz "ODD"
even: .asciiz "EVEN"
.text
.globl main
main:
  # grab command line stuff - a0 is arg count and a1 points to list of args
  move $s0, $a0
  move $s1, $a1

  # zero out these registers just to be safe
  move $s2, $zero
  move $s3, $zero
  move $s4, $zero

  # check if less than three arguments are given
  li $t0, 3 
  blt $a0, $t0, exit_on_error

  # parse the first number
  lw $a0, 4($s1)
  jal atoi
  move $s2, $v0

  # parse the second number
  lw $a0, 12($s1)
  jal atoi
  move $s3, $v0
  li $v0, 4

  # load a0 and a1 with two integers  
  lw $a0, 8($s1)
  lb $s4, ($a0)  
  
  move $a0, $s2
  move $a1, $s3
  move $a2, $s4
  
  move $t0, $a0 
  move $t1, $a1
  move $t2, $a2

  # "43" = "+"
  addi $t3, $zero, 43
  beq $t2, $t3, addition

  # "45" = "-"
  addi $t4, $zero, 45
  beq $t2, $t4, subtraction

  # "42" = "\*"
  addi $t5, $zero, 42
  beq $t2, $t5, multiply
  
addition: 
  add $t0, $a0, $a1
  b done

subtraction: 
  sub $t0, $a0, $a1
  b done

multiply:
  mul $t0, $a0, $a1
  b done

done:
  # move the result from t0 to v0 to print it
  li $t1, 2
  div $t0, $t1
  mfhi $t2
  
  beq $t2, 0, even1
  move $a0, $t0     
  li $v0, 1
  syscall

  la $a0, newline     
  li $v0, 4
  syscall
  b odd1

  li $v0, 10  # 10=exit
  syscall
odd1:
  li $v0, 4
  la $a0, odd
  syscall
  
  li $v0, 10
  syscall
even1:
  move $a0, $t0
  li $v0, 1
  syscall
  
  la $a0, newline
  li $v0, 4
  syscall
  
  li $v0, 4
  la $a0, even
  syscall
  
  li $v0, 10
  syscall
exit_on_error:
  li $v0, 4
  la $a0, usage_stmt     # print usage_stmt statement and exit
  syscall
  
  li $v0, 10             # 10=exit
  syscall

# --------- ATOI FUNCTION 
atoi:
    move $v0, $zero
    
    # detect sign
    li $t0, 1
    lbu $t1, 0($a0)
    bne $t1, 45, digit
    li $t0, -1
    addu $a0, $a0, 1

digit:
    # read character
    lbu $t1, 0($a0)
     
    # finish when non-digit encountered
    bltu $t1, 48, finish
    bgtu $t1, 57, finish
     
    # translate character into digit
    subu $t1, $t1, 48
     
    # multiply the accumulator by ten
    li $t2, 10
    mult $v0, $t2
    mflo $v0
     
    # add digit to the accumulator
    add $v0, $v0, $t1
     
    # next character
    addu $a0, $a0, 1
    b digit

finish:
    mult $v0, $t0
    mflo $v0
    jr $ra
#----------------------------------------
