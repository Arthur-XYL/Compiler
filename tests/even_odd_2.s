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
sub rsp, 8
mov rdi, rax
call snek_print
add rsp, 8
mov rax, [rsp + 0]
mov [rsp + 8], rax
sub rsp, 8
mov rbx, [rsp + 16]
mov [rsp + 0], rbx
call iseven
add rsp, 8
sub rsp, 8
mov rdi, rax
call snek_print
add rsp, 8
add rsp, 16
ret
isodd:
sub rsp, 16
mov rbx, [rsp + 24]
mov [rsp + 0], rbx
mov rax, 0
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
cmovnge rax, rbx
cmp rax, 3
je ifelse_1
mov rax, [rsp + 0]
mov [rsp + 8], rax
mov rax, 0
mov rbx, rax
or rbx, [rsp + 8]
and rbx, 1
test rbx, 1
jnz type_error
sub rax, [rsp + 8]
jo overflow_error
mov [rsp + 8], rax
mov rbx, [rsp + 8]
mov [rsp + 24], rbx
add rsp, 16
jmp isodd
jmp ifend_0
ifelse_1:
mov rax, 0
mov [rsp + 8], rax
mov rax, [rsp + 0]
mov rbx, rax
xor rbx, [rsp + 8]
test rbx, 1
jnz type_error
mov rcx, rax
mov rax, 3
mov rbx, 7
cmp rcx, [rsp + 8]
cmove rax, rbx
cmp rax, 3
je ifelse_3
mov rax, 3
jmp ifend_2
ifelse_3:
mov rax, [rsp + 0]
mov rbx, rax
and rbx, 1
cmp rbx, 0
jne type_error
sub rax, 2
jo overflow_error
mov [rsp + 8], rax
mov rbx, [rsp + 8]
mov [rsp + 24], rbx
add rsp, 16
jmp iseven
ifend_2:
ifend_0:
add rsp, 16
ret
iseven:
sub rsp, 16
mov rbx, [rsp + 24]
mov [rsp + 0], rbx
mov rax, 0
mov [rsp + 8], rax
mov rax, [rsp + 0]
mov rbx, rax
xor rbx, [rsp + 8]
test rbx, 1
jnz type_error
mov rcx, rax
mov rax, 3
mov rbx, 7
cmp rcx, [rsp + 8]
cmove rax, rbx
cmp rax, 3
je ifelse_5
mov rax, 7
jmp ifend_4
ifelse_5:
mov rax, [rsp + 0]
mov rbx, rax
and rbx, 1
cmp rbx, 0
jne type_error
sub rax, 2
jo overflow_error
mov [rsp + 8], rax
mov rbx, [rsp + 8]
mov [rsp + 24], rbx
add rsp, 16
jmp isodd
ifend_4:
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