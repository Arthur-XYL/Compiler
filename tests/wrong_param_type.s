section .text
global our_code_starts_here
extern snek_print
extern snek_error
our_code_starts_here:
mov r15, rsi 
sub rsp, 24
mov [rsp], rdi
call main
add rsp, 24
ret
main:
sub rsp, 32
mov rbx, [rsp + 40]
mov [rsp], rbx
mov rax, 7
mov [rsp + 8], rax
mov rax, 3
mov [rsp + 16], rax
mov rbx, [rsp + 8]
mov [rsp + 40], rbx
mov rbx, [rsp + 16]
mov [rsp + 48], rbx
add rsp, 32
jmp function
add rsp, 32
ret
function:
sub rsp, 32
mov rbx, [rsp + 40]
mov [rsp + 0], rbx
mov rbx, [rsp + 48]
mov [rsp + 8], rbx
mov rax, [rsp + 8]
mov [rsp + 16], rax
mov rax, [rsp + 0]
mov rbx, rax
or rbx, [rsp + 16]
and rbx, 1
test rbx, 1
jnz type_error
add rax, [rsp + 16]
jo overflow_error
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