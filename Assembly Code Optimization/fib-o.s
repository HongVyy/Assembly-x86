.text
.globl main
.ent main                 # entry point of main
main:
                          # setup the stack frame
  addi  $sp, $sp, -32     # stack frame is 32 bytes long
  sw    $ra, 20($sp)      # save return address ra
  sw    $fp, 16($sp)      # save old frame pointer
  addi  $fp, $sp, 28      # fp points to first word in bottom of frame 
                          # check if a command line argument was passed
  move  $s0, $a0          
  move  $s1, $a1          # s1 holds base address of cmdline arg array
  li $t0, 1
  ble   $a0, 1, noarg

  lw    $a0, 4($s1)       # load address to argument into $a0
  lbu   $t0, 0($a0)       # load first byte in string into $t0
  bgt   $t0, 57, exit     # exit if arg is > 9 
  blt   $t0, 48, exit     # exit if arg is < 0 
                          # we have an argument so check for validity
  jal   atoi              # convert the arg to an int
  move  $a0, $v0          # arg is now in $a0
  b     aok

noarg:                    # command-line argument
  li    $a0, 8            # force-feed arg into $a0 if we made it here

aok:                     
  li    $v0, 1            # print_int
  syscall                 # print the argument

  jal   fib               # call fibonacci function - result is in $v0
  move  $t0, $v0          # save fib result in $t0

  la    $a0, $LC          # load output string in $a0
  li    $v0, 4            # syscall print_string
  syscall

  move  $a0, $t0          # move fib result back to $a0
  li    $v0, 1            # syscall print_int
  syscall

  la    $a0, newline      # load output string in $a0
  li    $v0, 4            # syscall print_string
  syscall

  lw    $ra, 20($sp)      # Restore return address
  lw    $fp, 16($sp)      # Restore frame pointer
  addi  $sp, $sp, 32      # Pop stack frame

  li    $v0, 10           # 10 is the exit syscall
  syscall                 # do syscall

exit:
  la    $a0, errmsg       # load output string in $a0
  li    $v0, 4            # syscall print_string
  syscall                 #
  li    $v0, 10           # 10 is the exit syscall
  syscall                 # do syscall
  
.end main
.rdata
$LC:
  .asciiz " Fibonacci number is "
errmsg:
  .asciiz "Invalid argument passed.\n"
newline:
  .asciiz  "\n"

.text
# fib-- (callee-save method; does a lot of unnecessary work)
# Registers used:
#    $a0  - initially n. 
#    $s0  - parameter n. 
#    $s1  - fib (n - 1). 
#    $s2  - fib (n - 2).
.ent fib
fib:
     li $t6, 1
     bgt $a0, $t6, nonleaf
     move $v0, $a0
     jr $ra

nonleaf:
     subu  $sp, $sp, -32          # minimum frame size is 32
     sw    $ra, 28($sp)
     sw    $fp, 24($sp)            # preserve return address 
     sw    $s0, 20($sp)            # preserve $s0
     sw    $s1, 16($sp) 
     #sw    $s2, 12($sp)           # move frame pointer to base of fra
     addu  $fp, $sp, 32
     
     move  $s0, $a0               # grab n from caller
     blt   $s0, 3, fib_base_case  # if n < 3 we hit a stopping condition 
     sub   $a0, $s0, 1            # call fib (n - 1)
     jal   fib  

     move $s1, $v0
     sub $a0, $s0, 2
     jal   fib

     #move  $s2, $v0              # hold return value of fib(n-2) in s2
     
     add   $v0, $s1, $v0          # $v0 = fib(n-1) + fib(n-2)
     b     fib_return

fib_base_case:                    # base case always returns a 1 
     li  $v0, 1                   # set 1 as the return value 
fib_return:                       # prepare for return
     lw    $ra, 28($sp)
     lw    $fp, 24($sp)  
     lw    $s0, 20($sp)           #
     lw    $s1, 16($sp)
     #lw    $s2, 12($sp)           #
     addu  $sp, $sp, -32           #
     jr    $ra                    # return
.end fib
#--------------------------------
# atoi function
# No need to change this function
.ent atoi
atoi:
    move $v0, $zero
    li $t0, 1             # detect sign
    lbu $t1, 0($a0)
    bne $t1, 45, digit
    li $t0, -1
    addu $a0, $a0, 1
digit:                    # read character
    lbu $t1, 0($a0)
    bltu $t1, 48, finish  # finish when non-digit encountered
    bgtu $t1, 57, finish
    subu $t1, $t1, 48     # translate character into digit
    li $t2, 10            # multiply the accumulator by ten
    mult $v0, $t2
    mflo $v0
    add $v0, $v0, $t1     # add digit to the accumulator
    addu $a0, $a0, 1      # next character
    b digit
finish:
    mult $v0, $t0
    mflo $v0
    jr $ra                # end of atoi
.end atoi

