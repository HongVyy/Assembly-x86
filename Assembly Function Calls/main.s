.text
.globl  main
.ent  main

main:
  #PART 1

  la $a0, format1   # Load address of format string into $a0
  jal printf        # call printf

  la $a0, format2   # Load address of format string into $a0
  jal printf        # call printf

  la $a0, format3   # Load address of format string into $a0
  jal printf        # call printf

  #PART 2

  la $a0, string1   # Load address of format string into $a0
  jal printf        # call printf

  la $a0 fname_buf  #read the string and display firstname
  li $v0 8
  syscall 

  la $a0, string2   # Load address of format string into $a0
  jal printf        # call printf

  la $a0 lname_buf  #read the string and display lastname
  li $v0 8
  syscall

  la $a0, id       # Load address of format string into $a0
  jal printf       # call printf

  li $v0 5         # setup syscall 5 (read_int)
  syscall          # integer returned in $v0
  move $a0 $v0     # move the integer into register $a0

  li $v0, 10       #10 is exit system call
  syscall
.end  main
.data
format1: .asciiz "Go!\n"        # asciiz adds trailing null byte to string
format2: .asciiz "CSUB Roadrunners\n"  
format3: .asciiz "In 2023!\n\n"
 
string1: .asciiz "Firstname: "
fname_buf: .space 50

string2: .asciiz "Lastname: "
lname_buf: .space 50

id: .asciiz "ID: "
id_buf: .space 50
