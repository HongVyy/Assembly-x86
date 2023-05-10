;; $ gcc -D OPTIMIZE -o Lab12_opt Lab12.c
;; $ time ./Lab12_opt 2 40
;; ---> Optimization is set on.
;; 2^40 is 1099511627776
;; 1099511627776 log 2 is 40

;; real	0m0.003s
;; user	0m0.003s
;; sys	0m0.000s

section .rodata
	prompt1    db "Please enter a number: ",0   ; 0 is null character
	prompt2    db "Enter another number: ",0
	format_str db "The sum is: %ld.",10,0  ; 10 is LF 
	num_format db "%ld",0
section .text
	global main              ; main and _start are both valid entry points
	extern printf, scanf     ; these will be linked in from glibc 
main:
	push    rbp          ; save base pointer to the stack
	mov     rbp, rsp     ; base pointer = stack pointer 
	sub     rsp, 80      ; make room for integers on the stack
	push    rbx          ; push callee saved registers onto the stack 
	push    r12          ; push automatically decrements stack pointer
	push    r13          
	push    r14
	push    r15
	pushfq               ; push register flags onto the stack
    mov rax, 10
    mov [rbp-8], rax
    xor rax, rax
    mov [rbp-24], rax
add:
	mov rax, [rbp-8]
    test rax, rax
    jz print
    mov rdi, dword prompt1
    xor rax, rax
    call printf
    lea rsi, [rbp-16]
    mov rdi, dword num_format
    xor rax, rax
    call scanf
    mov rax, [rbp-24]
    mov rbx, [rbp-16]
    add rax,rbx
    mov [rbp-24], rax
    mov rax, [rbp-8]
    dec rax
    mov [rbp-8], rax
    jmp add
print: 
    mov rbx, [rbp-24]
    mov rsi, rbx
    mov rdi, dword format_str
    xor rax, rax
    call printf
exit:
    popfq
    pop     r15
    pop     r14
    pop     r13
    pop     r12
    pop     rbx
    add     rsp, 80       ; set back the stack level
    leave
    ret
