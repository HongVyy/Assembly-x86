  .data 
usage_stmt: .asciiz "\n Usage: spim-f fnums.s <int>\n"
  .text
  .globl main   
  .ent main      
main:
  addi  $sp, $sp, -32  # Stack frame is 32 bytes long
  sw  $ra, 20($sp)     # Save return address
  sw  $fp, 16($sp)     # Save old frame pointer
  addi  $fp, $sp, 28   # point to first word in bottom of frame 
  
  move $s0, $a0     # grab command line stuff -a0 is arg and a1 is points to list
  move $s1, $a1     # a0 holds the number of cmdline arg
  move $s2, $zero   # a1 is the base pointer
  move $s3, $zero   # zero out these register
  move $s4, $zero   # extra zeros

  li $t0, 2
  blt $a0, $t0, exit_on_error
  
  lw $a0, 4($s1)
  jal atoi

  move $s2, $v0
  move $a0, $s2
  move $t2, $s2
  
  jal  fact       # Call factorial function
  move $t0, $v0   # move result to t0
                  # display stuff now
  la $a0, msg     # address of msg
  li $v0, 4       # syscall 1=print string 
  syscall  
  move $a0, $t2   # Move fact result to $a0 to display it
  li   $v0, 1     # syscall 1=print int
  syscall  
  
  la $a0, msg1
  li $v0, 4
  syscall
  move $a0, $t0
  li $v0, 1
  syscall
  li  $a0, 10     # ascii LF char
  li  $v0, 11     # syscall 1=print char 
  syscall  
  lw  $ra, 20($sp)    # Restore return address
  lw  $fp, 16($sp)    # Restore frame pointer
  addi  $sp, $sp, 32  # Pop stack frame
  li  $v0, 10    # 10 is the code to exiting the program
  syscall        # Execute the exit
  .end main

  .rdata
msg: .asciiz "The fibonacci number of "
msg1: .asciiz " is "
  .text     
  .ent fact  

fact:
  
  addi $sp, $sp, -32  # Stack frame is 32 bytes long
  sw   $ra, 20($sp)   # Save return address
  sw   $fp, 16($sp)   # Save frame pointer
  addi $fp, $sp, 28   # Set up frame pointer
  sw   $a0, 0($fp)    # Save argument (n)

  lw    $v0, 0($fp)   # Load n
  li    $v0, 1
  beq   $a0, $v0, L1  # If n = 1, return to L1
  li    $v1, 2
  beq   $a0, $v1, L1  # If n = 2, return to L2
  j     L2            # Jump to return code

L2:

  lw    $v1, 0($fp)   # Load n
  addi  $v0, $v1, -1  # Compute n - 1
  move  $a0, $v0      # Move value to $a0
  jal   fact          # recursive call to factorial function

  sw    $v0, 4($sp)

  lw    $v1, 0($fp)   # Load n 
  addi  $v0, $v1, -2  # Compute n-2
  move  $a0, $v0      # Move value to $a0
  jal   fact

  move $t0, $v0
  lw $t1, 4($sp)
  addu  $v0, $t0, $t1

L1:

  lw   $ra, 20($sp)  # Restore $ra
  lw   $fp, 16($sp)  # Restore frame pointer
  addi $sp, $sp, 32  # Pop stack frame
  jr   $ra           # Return to caller

.end fact

.ent atoi
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

exit_on_error: 
    li $v0, 4
    la $a0, usage_stmt
    syscall

    li $v0, 10
    syscall

