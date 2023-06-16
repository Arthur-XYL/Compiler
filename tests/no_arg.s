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
sub rsp, 32
mov rbx, [rsp + 40]
mov [rsp], rbx
sub rsp, 8
call function
add rsp, 8
mov [rsp + 8], rax
mov rax, [rsp + 8]
mov rcx, rax
mov rax, 3
mov rbx, 7
and rcx, 1
cmp rcx, 0
cmove rax, rbx
mov [rsp + 16], rax
mov rax, [rsp + 8]
mov rbx, rax
xor rbx, [rsp + 16]
test rbx, 1
jnz type_error
mov rcx, rax
mov rax, 3
mov rbx, 7
cmp rcx, [rsp + 16]
cmove rax, rbx
cmp rax, 3
je ifelse_1
mov rax, [rsp + 8]
mov rcx, rax
mov rax, 3
mov rbx, 7
and rcx, 3
cmp rcx, 3
cmove rax, rbx
sub rsp, 8
mov rdi, rax
call snek_print
add rsp, 8
jmp ifend_0
ifelse_1:
mov rax, [rsp + 8]
mov rcx, rax
mov rax, 3
mov rbx, 7
and rcx, 1
cmp rcx, 0
cmove rax, rbx
sub rsp, 8
mov rdi, rax
call snek_print
add rsp, 8
ifend_0:
add rsp, 32
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