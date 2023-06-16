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
sub rsp, 32
mov rbx, [rsp + 40]
mov [rsp + 0], rbx
mov rax, 2
mov [rsp + 8], rax
mov rax, 2
mov [rsp + 16], rax
loop_begin_0:
mov rax, [rsp + 0]
mov [rsp + 24], rax
mov rax, [rsp + 8]
mov rbx, rax
or rbx, [rsp + 24]
and rbx, 1
test rbx, 1
jnz type_error
mov rcx, rax
mov rax, 3
mov rbx, 7
cmp rcx, [rsp + 24]
cmovnle rax, rbx
cmp rax, 3
je ifelse_3
mov rax, [rsp + 16]
jmp loop_end_1
jmp ifend_2
ifelse_3:
mov rax, [rsp + 8]
mov [rsp + 24], rax
mov rax, [rsp + 16]
mov rbx, rax
or rbx, [rsp + 24]
and rbx, 1
test rbx, 1
jnz type_error
sar rax, 1
imul rax, [rsp + 24]
jo overflow_error
mov [rsp + 16], rax
mov rax, 2
mov [rsp + 24], rax
mov rax, [rsp + 8]
mov rbx, rax
or rbx, [rsp + 24]
and rbx, 1
test rbx, 1
jnz type_error
add rax, [rsp + 24]
jo overflow_error
mov [rsp + 8], rax
ifend_2:
jmp loop_begin_0
loop_end_1:
add rsp, 32
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