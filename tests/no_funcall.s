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
mov rax, [rsp + 0]
mov rbx, rax
or rbx, [rsp + 8]
and rbx, 1
test rbx, 1
jnz type_error
add rax, [rsp + 8]
jo overflow_error
add rsp, 16
ret
function:
sub rsp, 0
mov rax, 7
add rsp, 0
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