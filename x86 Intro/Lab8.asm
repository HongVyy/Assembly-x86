
;;     $ nasm -f elf64 lab08.asm
;;     $ gcc -o lab08 lab08.o   # use gcc so glibc will be linked in
section .rodata
   prompt1 db "Enter an integer: ",0   ; 0 is null character
   prompt2 db "Enter another integer: ",0
   format_str db "The greater of %ld and %ld is %ld.",10,0  ; 10 is LF 
   format_str2 db " %ld and %ld are equal.",10,0
   msg db "The sum of %ld and %ld is %ld ",10,0
   num_format db "%ld",0

section .text
   global main              ; main and _start are both valid entry points
   extern printf, scanf     ; these will be linked in from glibc 
   main:
      push    rbp          ; save base pointer to the stack
      mov     rbp, rsp     ; base pointer = stack pointer 
      sub     rsp, 16      ; make room for two long integers on the stack
      push    rbx          ; push callee saved registers onto the stack 
      push    r12          ; push automatically decrements stack pointer
      push    r13          
      push    r14
      push    r15
      pushfq               ; push register flags onto the stack

      ; prompt user for first integer 
      mov    rdi, dword prompt1    ; double word is 4 bytes; a word is 2 bytes
                                   ; rdi = 32-bit address of prompt1
      xor    rax, rax              ; rax is return value register - zero it out
      call   printf                ; call the C function from glibc 

      ; read first integer 
      lea    rsi, [rbp-8]          ; load effective address - this instruction
                                   ; computes the address 8 bytes above the

      ; initialize location of first integer
                                   ; will be stored in this location  
      mov    rdi, dword num_format ; load rdi with address to format string
      xor    rax, rax              ; zero out return value register
      call   scanf                 ; call C function
                                   
      ; prompt user for second integer 
      mov    rdi, dword prompt2
      xor    rax, rax
      call   printf

      ; read second integer 
      lea    rsi, [rbp-16]
      mov    rdi, dword num_format
      xor    rax, rax
      call   scanf 

      ; determine if num2 (second integer) is greater than num1 (first integer)
      xor     rbx, rbx      ; RBX = 0x0
      mov     rax, [rbp-16] ; RAX = num2 ; load rax with value at rdb-16
      cmp     rax, [rbp-8]  ; compute (num1) - (num2) and set condition codes  
      je      equalto
      jl     lessthan      ; jump if num1 < num2     
      
      ; num1 > num2 
      mov     rdi, dword format_str
      mov     rsi, [rbp-8]     ; num1
      mov     rdx, [rbp-16]    ; num2
      mov     rcx, [rbp-16]    ; greater of the two 
      xor     rax, rax
      call printf
      jmp sum   
      
      lessthan:      
      ; num1 < num2
      mov     rdi, dword format_str
      mov     rsi, [rbp-8]   ; num1
      mov     rdx, [rbp-16]  ; num2
      mov     rcx, [rbp-8]   ; greater of the two
      xor     rax, rax
      call printf
      jmp sum

      equalto: 
      mov     rdi, dword format_str2
      mov     rsi, [rbp-8]   ; num1
      mov     rdx, [rbp-16]  ; num2
      mov     rcx, [rbp-8]   ; greater of the two
      xor     rax, rax
      call printf
      jmp sum

      sum: 
      mov rdi, dword msg
      mov rsi, [rbp-8]
      mov rdx, [rbp-16]
      mov rcx, [rbp-8]

      add rcx, rdx
      jmp exit  
exit:
      call    printf
      ; epilogue
      popfq
      pop     r15
      pop     r14
      pop     r13
      pop     r12
      pop     rbx
      add     rsp, 16                     ; set back the stack level
      leave
      ret
