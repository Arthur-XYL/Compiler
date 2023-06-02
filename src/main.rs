use std::env;
use std::fs::File;
use std::io::prelude::*;

mod compile;
mod expr;
mod parse;
use compile::compile_exprs;
use parse::parse_exprs;

fn main() -> std::io::Result<()> {
    let args: Vec<String> = env::args().collect();
    let in_name = &args[1];
    let out_name = &args[2];
    let mut in_file = File::open(in_name)?;
    let mut in_contents = String::new();
    in_file.read_to_string(&mut in_contents)?;

    let exprs = parse_exprs(&in_contents);
    let result = compile_exprs(&exprs);

    let asm_program = format!(
        "section .text
global our_code_starts_here
extern snek_print
extern snek_error
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
our_code_starts_here:
mov r15, rsi{result}
ret"
    );

    let mut out_file = File::create(out_name)?;
    out_file.write_all(asm_program.as_bytes())?;

    Ok(())
}
