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
sub rsp, 24
call no_arg
add rsp, 24
sub rsp, 8
mov rdi, rax
call snek_print
add rsp, 8
mov rax, 2
mov [rsp + 8], rax
sub rsp, 24
mov rbx, [rsp + 32]
mov [rsp + 0], rbx
call one_arg
add rsp, 24
sub rsp, 8
mov rdi, rax
call snek_print
add rsp, 8
mov rax, 4
mov [rsp + 8], rax
mov rax, 6
mov [rsp + 16], rax
sub rsp, 24
mov rbx, [rsp + 32]
mov [rsp + 0], rbx
mov rbx, [rsp + 40]
mov [rsp + 8], rbx
call two_arg
add rsp, 24
sub rsp, 8
mov rdi, rax
call snek_print
add rsp, 8
mov rax, 8
mov [rsp + 8], rax
mov rax, 10
mov [rsp + 16], rax
mov rax, 12
mov [rsp + 24], rax
sub rsp, 24
mov rbx, [rsp + 32]
mov [rsp + 0], rbx
mov rbx, [rsp + 40]
mov [rsp + 8], rbx
mov rbx, [rsp + 48]
mov [rsp + 16], rbx
call three_arg
add rsp, 24
sub rsp, 8
mov rdi, rax
call snek_print
add rsp, 8
add rsp, 32
ret
no_arg:
sub rsp, 0
mov rax, 7
sub rsp, 8
mov rdi, rax
call snek_print
add rsp, 8
add rsp, 0
ret
one_arg:
sub rsp, 16
mov rbx, [rsp + 24]
mov [rsp + 0], rbx
mov rax, [rsp + 0]
sub rsp, 8
mov rdi, rax
call snek_print
add rsp, 8
add rsp, 16
ret
two_arg:
sub rsp, 16
mov rbx, [rsp + 24]
mov [rsp + 0], rbx
mov rbx, [rsp + 32]
mov [rsp + 8], rbx
mov rax, [rsp + 0]
sub rsp, 8
mov rdi, rax
call snek_print
add rsp, 8
mov rax, [rsp + 8]
sub rsp, 8
mov rdi, rax
call snek_print
add rsp, 8
add rsp, 16
ret
three_arg:
sub rsp, 32
mov rbx, [rsp + 40]
mov [rsp + 0], rbx
mov rbx, [rsp + 48]
mov [rsp + 8], rbx
mov rbx, [rsp + 56]
mov [rsp + 16], rbx
mov rax, [rsp + 0]
sub rsp, 8
mov rdi, rax
call snek_print
add rsp, 8
mov rax, [rsp + 8]
sub rsp, 8
mov rdi, rax
call snek_print
add rsp, 8
mov rax, [rsp + 16]
sub rsp, 8
mov rdi, rax
call snek_print
add rsp, 8
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