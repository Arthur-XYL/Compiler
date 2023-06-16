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
sub rsp, 48
mov rbx, [rsp + 56]
mov [rsp], rbx
mov rax, 1
mov [rsp + 8], rax
mov rax, 6
mov [rsp + 16], rax
mov rax, 3
mov [rsp + 24], rax
mov rax, 10
mov [rsp + 32], rax
mov rcx, r15
mov rbx, 3
mov [r15], rbx
add r15, 8
mov rbx, [rsp + 16]
mov [r15], rbx
add r15, 8
mov rbx, [rsp + 24]
mov [r15], rbx
add r15, 8
mov rbx, [rsp + 32]
mov [r15], rbx
add r15, 8
mov rax, rcx
add rax, 1
mov [rsp + 16], rax
mov rax, 3
mov [rsp + 24], rax
mov rcx, r15
mov rbx, 2
mov [r15], rbx
add r15, 8
mov rbx, [rsp + 16]
mov [r15], rbx
add r15, 8
mov rbx, [rsp + 24]
mov [r15], rbx
add r15, 8
mov rax, rcx
add rax, 1
mov [rsp + 16], rax
mov rcx, r15
mov rbx, 2
mov [r15], rbx
add r15, 8
mov rbx, [rsp + 8]
mov [r15], rbx
add r15, 8
mov rbx, [rsp + 16]
mov [r15], rbx
add r15, 8
mov rax, rcx
add rax, 1
mov [rsp + 8], rax
mov rax, [rsp + 8]
mov [rsp + 16], rax
mov rax, 2
mov rbx, [rsp + 16]
cmp rbx, 1
je type_error
and rbx, 3
cmp rbx, 1
jne type_error
mov rbx, rax
and rbx, 1
cmp rbx, 0
jne type_error
mov rcx, [rsp + 16]
mov rdx, rax
sub rcx, 1
sar rdx, 1
cmp rdx, [rcx]
jge index_out_of_bound_error
add rcx, 8
index_begin_0:
cmp rdx, 0
je index_end_1
sub rdx, 1
add rcx, 8
jmp index_begin_0
index_end_1:
mov rax, [rcx]
mov rbx, rcx
and rbx, 3
cmp rbx, 1
cmove rax, rcx
mov [rsp + 16], rax
mov rax, 0
mov rbx, [rsp + 16]
cmp rbx, 1
je type_error
and rbx, 3
cmp rbx, 1
jne type_error
mov rbx, rax
and rbx, 1
cmp rbx, 0
jne type_error
mov rcx, [rsp + 16]
mov rdx, rax
sub rcx, 1
sar rdx, 1
cmp rdx, [rcx]
jge index_out_of_bound_error
add rcx, 8
index_begin_2:
cmp rdx, 0
je index_end_3
sub rdx, 1
add rcx, 8
jmp index_begin_2
index_end_3:
mov rax, [rcx]
mov rbx, rcx
and rbx, 3
cmp rbx, 1
cmove rax, rcx
mov [rsp + 16], rax
mov rax, 4
mov rbx, [rsp + 16]
cmp rbx, 1
je type_error
and rbx, 3
cmp rbx, 1
jne type_error
mov rbx, rax
and rbx, 1
cmp rbx, 0
jne type_error
mov rcx, [rsp + 16]
mov rdx, rax
sub rcx, 1
sar rdx, 1
cmp rdx, [rcx]
jge index_out_of_bound_error
add rcx, 8
index_begin_4:
cmp rdx, 0
je index_end_5
sub rdx, 1
add rcx, 8
jmp index_begin_4
index_end_5:
mov rax, [rcx]
mov rbx, rcx
and rbx, 3
cmp rbx, 1
cmove rax, rcx
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