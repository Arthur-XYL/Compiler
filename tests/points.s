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
sub rsp, 48
mov rbx, [rsp + 56]
mov [rsp], rbx
mov rax, 8
mov [rsp + 8], rax
mov rax, 20
mov [rsp + 16], rax
sub rsp, 24
mov rbx, [rsp + 32]
mov [rsp + 0], rbx
mov rbx, [rsp + 40]
mov [rsp + 8], rbx
call coor
add rsp, 24
mov [rsp + 8], rax
mov rax, 4
mov [rsp + 16], rax
mov rax, 4
mov [rsp + 24], rax
sub rsp, 24
mov rbx, [rsp + 40]
mov [rsp + 0], rbx
mov rbx, [rsp + 48]
mov [rsp + 8], rbx
call coor
add rsp, 24
mov [rsp + 16], rax
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
mov rax, [rsp + 8]
mov [rsp + 24], rax
mov rax, [rsp + 16]
mov [rsp + 32], rax
sub rsp, 24
mov rbx, [rsp + 48]
mov [rsp + 0], rbx
mov rbx, [rsp + 56]
mov [rsp + 8], rbx
call coor_combine
add rsp, 24
sub rsp, 8
mov rdi, rax
call snek_print
add rsp, 8
mov rax, [rsp + 8]
mov [rsp + 24], rax
mov rax, [rsp + 16]
mov [rsp + 32], rax
sub rsp, 24
mov rbx, [rsp + 48]
mov [rsp + 0], rbx
mov rbx, [rsp + 56]
mov [rsp + 8], rbx
call coor_combine
add rsp, 24
mov [rsp + 24], rax
mov rax, 8
mov [rsp + 32], rax
mov rax, 16
mov [rsp + 40], rax
mov rcx, r15
mov rbx, 2
mov [r15], rbx
add r15, 8
mov rbx, [rsp + 32]
mov [r15], rbx
add r15, 8
mov rbx, [rsp + 40]
mov [r15], rbx
add r15, 8
mov rax, rcx
add rax, 1
mov [rsp + 32], rax
sub rsp, 24
mov rbx, [rsp + 48]
mov [rsp + 0], rbx
mov rbx, [rsp + 56]
mov [rsp + 8], rbx
call coor_combine
add rsp, 24
sub rsp, 8
mov rdi, rax
call snek_print
add rsp, 8
add rsp, 48
ret
coor:
sub rsp, 32
mov rbx, [rsp + 40]
mov [rsp + 0], rbx
mov rbx, [rsp + 48]
mov [rsp + 8], rbx
mov rax, [rsp + 0]
mov rcx, rax
mov rax, 3
mov rbx, 7
and rcx, 1
cmp rcx, 0
cmove rax, rbx
cmp rax, 3
je ifelse_1
mov rax, [rsp + 8]
mov rcx, rax
mov rax, 3
mov rbx, 7
and rcx, 1
cmp rcx, 0
cmove rax, rbx
cmp rax, 3
je ifelse_3
mov rax, [rsp + 0]
mov [rsp + 16], rax
mov rax, [rsp + 8]
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
jmp ifend_2
ifelse_3:
mov rax, [rsp + 0]
mov [rsp + 16], rax
mov rax, 0
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
ifend_2:
jmp ifend_0
ifelse_1:
mov rax, [rsp + 8]
mov rcx, rax
mov rax, 3
mov rbx, 7
and rcx, 1
cmp rcx, 0
cmove rax, rbx
cmp rax, 3
je ifelse_5
mov rax, 0
mov [rsp + 16], rax
mov rax, [rsp + 8]
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
jmp ifend_4
ifelse_5:
mov rax, 0
mov [rsp + 16], rax
mov rax, 0
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
ifend_4:
ifend_0:
add rsp, 32
ret
coor_combine:
sub rsp, 48
mov rbx, [rsp + 56]
mov [rsp + 0], rbx
mov rbx, [rsp + 64]
mov [rsp + 8], rbx
mov rax, [rsp + 8]
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
index_begin_6:
cmp rdx, 0
je index_end_7
sub rdx, 1
add rcx, 8
jmp index_begin_6
index_end_7:
mov rax, [rcx]
mov rbx, rcx
and rbx, 3
cmp rbx, 1
cmove rax, rcx
mov [rsp + 16], rax
mov rax, [rsp + 0]
mov [rsp + 24], rax
mov rax, 0
mov rbx, [rsp + 24]
cmp rbx, 1
je type_error
and rbx, 3
cmp rbx, 1
jne type_error
mov rbx, rax
and rbx, 1
cmp rbx, 0
jne type_error
mov rcx, [rsp + 24]
mov rdx, rax
sub rcx, 1
sar rdx, 1
cmp rdx, [rcx]
jge index_out_of_bound_error
add rcx, 8
index_begin_8:
cmp rdx, 0
je index_end_9
sub rdx, 1
add rcx, 8
jmp index_begin_8
index_end_9:
mov rax, [rcx]
mov rbx, rcx
and rbx, 3
cmp rbx, 1
cmove rax, rcx
mov rbx, rax
or rbx, [rsp + 16]
and rbx, 1
test rbx, 1
jnz type_error
add rax, [rsp + 16]
jo overflow_error
mov [rsp + 16], rax
mov rax, [rsp + 8]
mov [rsp + 24], rax
mov rax, 2
mov rbx, [rsp + 24]
cmp rbx, 1
je type_error
and rbx, 3
cmp rbx, 1
jne type_error
mov rbx, rax
and rbx, 1
cmp rbx, 0
jne type_error
mov rcx, [rsp + 24]
mov rdx, rax
sub rcx, 1
sar rdx, 1
cmp rdx, [rcx]
jge index_out_of_bound_error
add rcx, 8
index_begin_10:
cmp rdx, 0
je index_end_11
sub rdx, 1
add rcx, 8
jmp index_begin_10
index_end_11:
mov rax, [rcx]
mov rbx, rcx
and rbx, 3
cmp rbx, 1
cmove rax, rcx
mov [rsp + 24], rax
mov rax, [rsp + 0]
mov [rsp + 32], rax
mov rax, 2
mov rbx, [rsp + 32]
cmp rbx, 1
je type_error
and rbx, 3
cmp rbx, 1
jne type_error
mov rbx, rax
and rbx, 1
cmp rbx, 0
jne type_error
mov rcx, [rsp + 32]
mov rdx, rax
sub rcx, 1
sar rdx, 1
cmp rdx, [rcx]
jge index_out_of_bound_error
add rcx, 8
index_begin_12:
cmp rdx, 0
je index_end_13
sub rdx, 1
add rcx, 8
jmp index_begin_12
index_end_13:
mov rax, [rcx]
mov rbx, rcx
and rbx, 3
cmp rbx, 1
cmove rax, rcx
mov rbx, rax
or rbx, [rsp + 24]
and rbx, 1
test rbx, 1
jnz type_error
add rax, [rsp + 24]
jo overflow_error
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