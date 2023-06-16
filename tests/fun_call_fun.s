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
sub rsp, 64
mov rbx, [rsp + 72]
mov [rsp], rbx
mov rax, 20
mov [rsp + 8], rax
sub rsp, 24
call no_arg
add rsp, 24
mov [rsp + 16], rax
sub rsp, 24
call no_arg
add rsp, 24
mov [rsp + 24], rax
sub rsp, 24
mov rbx, [rsp + 48]
mov [rsp + 0], rbx
call one_arg
add rsp, 24
mov [rsp + 24], rax
sub rsp, 24
mov rbx, [rsp + 40]
mov [rsp + 0], rbx
mov rbx, [rsp + 48]
mov [rsp + 8], rbx
call two_arg
add rsp, 24
mov [rsp + 16], rax
mov rax, 0
mov [rsp + 24], rax
mov rax, 84
mov [rsp + 32], rax
sub rsp, 24
mov rbx, [rsp + 48]
mov [rsp + 0], rbx
mov rbx, [rsp + 56]
mov [rsp + 8], rbx
call two_arg
add rsp, 24
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
mov [rsp + 8], rax
mov rax, 18
mov [rsp + 16], rax
sub rsp, 24
mov rbx, [rsp + 40]
mov [rsp + 0], rbx
call one_arg
add rsp, 24
mov [rsp + 16], rax
mov rax, 174
mov [rsp + 24], rax
mov rax, 68
mov [rsp + 32], rax
mov rax, -46
mov [rsp + 40], rax
sub rsp, 24
mov rbx, [rsp + 48]
mov [rsp + 0], rbx
mov rbx, [rsp + 56]
mov [rsp + 8], rbx
mov rbx, [rsp + 64]
mov [rsp + 16], rbx
call three_arg
add rsp, 24
mov rbx, rax
or rbx, [rsp + 16]
and rbx, 1
test rbx, 1
jnz type_error
add rax, [rsp + 16]
jo overflow_error
mov [rsp + 16], rax
mov rax, 18
mov [rsp + 24], rax
mov rax, 18
mov [rsp + 32], rax
sub rsp, 24
mov rbx, [rsp + 48]
mov [rsp + 0], rbx
mov rbx, [rsp + 56]
mov [rsp + 8], rbx
call two_arg
add rsp, 24
mov [rsp + 24], rax
mov rax, 40
mov [rsp + 32], rax
mov rax, 96
mov [rsp + 40], rax
mov rax, 42
mov [rsp + 48], rax
sub rsp, 24
mov rbx, [rsp + 56]
mov [rsp + 0], rbx
mov rbx, [rsp + 64]
mov [rsp + 8], rbx
mov rbx, [rsp + 72]
mov [rsp + 16], rbx
call three_arg
add rsp, 24
mov [rsp + 32], rax
sub rsp, 24
call no_arg
add rsp, 24
mov rbx, rax
or rbx, [rsp + 32]
and rbx, 1
test rbx, 1
jnz type_error
add rax, [rsp + 32]
jo overflow_error
mov rbx, rax
or rbx, [rsp + 24]
and rbx, 1
test rbx, 1
jnz type_error
sar rax, 1
imul rax, [rsp + 24]
jo overflow_error
mov rbx, rax
or rbx, [rsp + 16]
and rbx, 1
test rbx, 1
jnz type_error
sub rax, [rsp + 16]
jo overflow_error
mov [rsp + 16], rax
sub rsp, 24
call no_arg
add rsp, 24
mov [rsp + 24], rax
mov rbx, [rsp + 8]
mov [rsp + 72], rbx
mov rbx, [rsp + 16]
mov [rsp + 80], rbx
mov rbx, [rsp + 24]
mov [rsp + 88], rbx
add rsp, 64
jmp three_arg
add rsp, 64
ret
no_arg:
sub rsp, 32
mov rax, 2
mov [rsp + 0], rax
mov rax, 4
mov [rsp + 8], rax
mov rax, 6
mov [rsp + 16], rax
mov rbx, [rsp + 0]
mov [rsp + 40], rbx
mov rbx, [rsp + 8]
mov [rsp + 48], rbx
mov rbx, [rsp + 16]
mov [rsp + 56], rbx
add rsp, 32
jmp three_arg
add rsp, 32
ret
one_arg:
sub rsp, 16
mov rbx, [rsp + 24]
mov [rsp + 0], rbx
mov rax, [rsp + 0]
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
add rsp, 16
ret
two_arg:
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
mov [rsp + 16], rax
mov rbx, [rsp + 16]
mov [rsp + 40], rbx
add rsp, 32
jmp one_arg
add rsp, 32
ret
three_arg:
sub rsp, 48
mov rbx, [rsp + 56]
mov [rsp + 0], rbx
mov rbx, [rsp + 64]
mov [rsp + 8], rbx
mov rbx, [rsp + 72]
mov [rsp + 16], rbx
mov rax, [rsp + 16]
mov [rsp + 24], rax
mov rax, [rsp + 0]
mov rbx, rax
or rbx, [rsp + 24]
and rbx, 1
test rbx, 1
jnz type_error
sar rax, 1
imul rax, [rsp + 24]
jo overflow_error
mov [rsp + 24], rax
mov rax, [rsp + 16]
mov [rsp + 32], rax
mov rax, [rsp + 8]
mov rbx, rax
or rbx, [rsp + 32]
and rbx, 1
test rbx, 1
jnz type_error
sub rax, [rsp + 32]
jo overflow_error
mov [rsp + 32], rax
mov rbx, [rsp + 24]
mov [rsp + 56], rbx
mov rbx, [rsp + 32]
mov [rsp + 64], rbx
add rsp, 48
jmp two_arg
add rsp, 48
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