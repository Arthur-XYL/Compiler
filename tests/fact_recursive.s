section .text
global our_code_starts_here
extern snek_print
extern snek_error
our_code_starts_here:
mov r15, rsi 
sub rsp, 8
mov [rsp], rdi
call main
add rsp, 8
ret
main:
sub rsp, 16
mov rbx, [rsp + 24]
mov [rsp], rbx
mov rax, [rsp + 0]
mov [rsp + 8], rax
mov rbx, [rsp + 8]
mov [rsp + 24], rbx
add rsp, 16
jmp fact
add rsp, 16
ret
fact:
sub rsp, 16
mov rbx, [rsp + 24]
mov [rsp + 0], rbx
mov rax, 2
mov [rsp + 8], rax
mov rax, [rsp + 0]
mov rbx, rax
or rbx, [rsp + 8]
and rbx, 1
test rbx, 1
jnz type_error
mov rcx, rax
mov rax, 3
mov rbx, 7
cmp rcx, [rsp + 8]
cmovng rax, rbx
cmp rax, 3
je ifelse_1
mov rax, 2
jmp ifend_0
ifelse_1:
mov rax, 2
mov [rsp + 8], rax
mov rax, [rsp + 0]
mov rbx, rax
or rbx, [rsp + 8]
and rbx, 1
test rbx, 1
jnz type_error
sub rax, [rsp + 8]
jo overflow_error
mov [rsp + 8], rax
sub rsp, 8
mov rbx, [rsp + 16]
mov [rsp + 0], rbx
call fact
add rsp, 8
mov [rsp + 8], rax
mov rax, [rsp + 0]
mov rbx, rax
or rbx, [rsp + 8]
and rbx, 1
test rbx, 1
jnz type_error
sar rax, 1
imul rax, [rsp + 8]
jo overflow_error
ifend_0:
add rsp, 16
ret
type_error:
sub rsp, 8
mov rdi, 1
call snek_error
overflow_error:
sub rsp, 8
mov rdi, 2
call snek_error
index_out_of_bound_error:
sub rsp, 8
mov rdi, 3
call snek_error