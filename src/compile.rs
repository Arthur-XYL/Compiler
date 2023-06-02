use std::collections::HashMap;

use crate::expr::Expr;
use crate::expr::Op1;
use crate::expr::Op2;

pub fn compile_exprs(exprs: &[Expr]) -> String {
    if exprs.len() == 0 {
        panic!("Invalid expression");
    }

    let mut env = HashMap::new();
    env.insert("input".to_string(), 0 as u32);
    let mut fun_map = HashMap::new();
    let mut label = 0;

    for fun in exprs.iter().take(exprs.len() - 1) {
        match fun {
            Expr::FunDef(name, params, body) => match fun_map.get(name) {
                Some(_val) => panic!("Invalid: multiple functions defined with same name"),
                None => {
                    fun_map.insert(
                        name.clone(),
                        (params.len() as u32, params.len() as u32 + depth(body)),
                    );
                }
            },
            _ => panic!("Invalid: expected function definition"),
        }
    }

    let mut func_instrs = String::new();
    for fun in exprs.iter().take(exprs.len() - 1) {
        match fun {
            Expr::FunDef(name, params, body) => {
                let mut fun_env = HashMap::new();
                let mut si_ = 1;

                let mut param_list = Vec::new();
                for param in params {
                    if param_list.contains(param) {
                        panic!("Invalid: function parameters has duplicate name")
                    }
                    param_list.push(param.to_string());
                    fun_env.insert(param.to_string(), si_);
                    si_ += 1;
                }

                let fun_label = format!("fun_{}", name);
                let body_instrs =
                    compile_expr(body, si_, &mut fun_env, &mut fun_map, "", true, &mut label);
                func_instrs.push_str(&format!(
                    "
{fun_label}:{body_instrs}
ret"
                ));
            }
            _ => panic!("Expected function definition"),
        }
    }

    match exprs.last().expect("Expected at least one expression") {
        Expr::FunDef(_name, _params, _body) => panic!("Invalid: no expression found"),
        _ => {
            let expr = exprs.last().expect("Expected at least one expression");
            let expr_instrs = compile_expr(expr, 1, &mut env, &mut fun_map, "", true, &mut label);
            let depth = 1 + depth(expr);

            let offset = if depth % 2 == 0 {
                depth * 8
            } else {
                (depth + 1) * 8
            };

            format!(
                "
jmp main{func_instrs}
main:
sub rsp, {offset}
mov [rsp], rdi{expr_instrs}
add rsp, {offset}",
            )
        }
    }
}

fn compile_expr(
    e: &Expr,
    si: u32,
    env: &mut HashMap<String, u32>,
    fun_map: &mut HashMap<String, (u32, u32)>,
    break_target: &str,
    tail: bool,
    label: &mut u32,
) -> String {
    match e {
        Expr::Number(n) => {
            if n > &4611686018427387903 || n < &-4611686018427387904 {
                panic!("Invalid: overflow for number")
            }
            format!("\nmov rax, {}", *n << 1)
        }
        Expr::Boolean(b) => {
            let val = if *b { 7 } else { 3 };
            format!("\nmov rax, {}", val)
        }
        Expr::Id(id) => {
            if id == "nil" {
                format!("\nmov rax, 1")
            } else {
                match env.get(id) {
                    Some(stack_index) => format!("\nmov rax, [rsp + {}]", *stack_index * 8),
                    None => panic!("Unbound variable identifier {id}"),
                }
            }
        }

        Expr::Let(bindings, body) => {
            let mut instrs = String::new();
            let mut si_ = si;
            let mut new_env = env.clone();

            let mut binding_list = Vec::new();
            for (id, e) in bindings {
                if binding_list.contains(id) {
                    panic!("Duplicate binding for {}", id);
                }
                binding_list.push(id.to_string());

                // compute the binding expression
                let bind_instrs =
                    compile_expr(e, si_, &mut new_env, fun_map, break_target, false, label);
                instrs.push_str(&bind_instrs);
                instrs.push_str(&format!("\nmov [rsp + {}], rax", si_ * 8));
                new_env.insert(id.clone(), si_);
                si_ += 1;
            }

            // evaluate body
            let body_instrs =
                compile_expr(body, si_, &mut new_env, fun_map, break_target, tail, label);
            instrs.push_str(&body_instrs);
            instrs
        }
        Expr::UnOp(op, e) => {
            let mut instrs = compile_expr(e, si, env, fun_map, break_target, false, label);
            match op {
                Op1::Add1 => {
                    instrs.push_str(&check_is_num("rax"));
                    instrs.push_str(&format!("\nadd rax, 2"));
                    instrs.push_str(&format!("\njo overflow_error"));
                }
                Op1::Sub1 => {
                    instrs.push_str(&check_is_num("rax"));
                    instrs.push_str(&format!("\nsub rax, 2"));
                    instrs.push_str(&format!("\njo overflow_error"));
                }
                Op1::IsNum => instrs.push_str(&is_num("rax")),
                Op1::IsBool => instrs.push_str(&is_bool("rax")),
                Op1::Print => {
                    instrs.push_str(&format!(
                        "
sub rsp, 8
mov rdi, rax
call snek_print
add rsp, 8",
                    ));
                }
            }
            instrs
        }
        Expr::BinOp(op, e1, e2) => {
            let mut instrs = String::new();
            let e2_instrs = compile_expr(e2, si, env, fun_map, break_target, false, label);
            let e1_instrs = compile_expr(e1, si + 1, env, fun_map, break_target, false, label);
            let e2_location = format!("[rsp + {}]", si * 8);

            instrs.push_str(&format!(
                "{e2_instrs}
mov {e2_location}, rax{e1_instrs}"
            ));

            match op {
                Op2::Plus => {
                    instrs.push_str(&check_both_type_same_num("rax", &e2_location));
                    instrs.push_str(&format!("\nadd rax, {e2_location}"));
                    instrs.push_str("\njo overflow_error");
                }
                Op2::Minus => {
                    instrs.push_str(&check_both_type_same_num("rax", &e2_location));
                    instrs.push_str(&format!("\nsub rax, {e2_location}"));
                    instrs.push_str("\njo overflow_error");
                }
                Op2::Times => {
                    instrs.push_str(&check_both_type_same_num("rax", &e2_location));
                    instrs.push_str("\nsar rax, 1");
                    instrs.push_str(&format!("\nimul rax, {e2_location}"));
                    instrs.push_str("\njo overflow_error");
                }
                Op2::Equal => {
                    instrs.push_str(&check_both_type_same("rax", &e2_location));
                    instrs.push_str(&cmp_instrs("rax", &e2_location, "cmove"));
                }
                Op2::Greater => {
                    instrs.push_str(&check_both_type_same_num("rax", &e2_location));
                    instrs.push_str(&cmp_instrs("rax", &e2_location, "cmovnle"));
                }
                Op2::GreaterEqual => {
                    instrs.push_str(&check_both_type_same_num("rax", &e2_location));
                    instrs.push_str(&cmp_instrs("rax", &e2_location, "cmovnl"));
                }
                Op2::Less => {
                    instrs.push_str(&check_both_type_same_num("rax", &e2_location));
                    instrs.push_str(&cmp_instrs("rax", &e2_location, "cmovnge"));
                }
                Op2::LessEqual => {
                    instrs.push_str(&check_both_type_same_num("rax", &e2_location));
                    instrs.push_str(&cmp_instrs("rax", &e2_location, "cmovng"));
                }
            }
            instrs
        }
        Expr::If(cond, thn, els) => {
            let end_label = new_label(label, "ifend");
            let else_label = new_label(label, "ifelse");
            let cond_instrs = compile_expr(cond, si, env, fun_map, break_target, false, label);
            let thn_intrs = compile_expr(thn, si, env, fun_map, break_target, tail, label);
            let els_intrs = compile_expr(els, si, env, fun_map, break_target, tail, label);
            format!(
                "{cond_instrs}
cmp rax, 3
je {else_label}{thn_intrs}
jmp {end_label}
{else_label}:{els_intrs}
{end_label}:"
            )
        }
        Expr::Loop(body) => {
            let begin_label = new_label(label, "loop_begin");
            let end_label = new_label(label, "loop_end");
            let instrs = compile_expr(body, si, env, fun_map, &end_label, false, label);
            format!(
                "
{begin_label}:{instrs}
jmp {begin_label}
{end_label}:"
            )
        }
        Expr::Break(body) => {
            if break_target == "" {
                panic!("break outside of loop")
            }

            let instrs = compile_expr(body, si, env, fun_map, break_target, false, label);
            format!(
                "{instrs}
jmp {break_target}"
            )
        }
        Expr::Set(id, e) => match env.get(id) {
            Some(stack_index) => {
                let id_location = format!("[rsp + {}]", *stack_index * 8);

                let instrs = compile_expr(e, si, env, fun_map, break_target, false, label);
                format!(
                    "{instrs}
mov {id_location}, rax"
                )
            }
            None => panic!("Unbound variable identifier {}", id),
        },

        Expr::Block(es) => {
            let mut instrs = String::new();

            // evaluate each expression except for the last one
            for index in 0..es.len() - 1 {
                let expression =
                    compile_expr(&es[index], si, env, fun_map, break_target, false, label);
                instrs.push_str(&expression);
            }

            // evaluate the last expression and pass in the tail flag
            if let Some(last_expr) = es.last() {
                let expression =
                    compile_expr(last_expr, si, env, fun_map, break_target, tail, label);
                instrs.push_str(&expression);
            }

            instrs
        }

        Expr::Tuple(es) => {
            let mut instrs = String::new();
            for (index, e) in es.iter().enumerate() {
                let si_ = si + index as u32;
                let expression = compile_expr(e, si_, env, fun_map, break_target, false, label);
                instrs.push_str(&expression);
                instrs.push_str(&format!("\nmov [rsp + {}], rax", si_ * 8));
            }

            // first element of the tuple is its length
            instrs.push_str(&format!(
                "
mov rcx, r15
mov rbx, {}
mov [r15], rbx
add r15, 8",
                es.len()
            ));

            // move elements from stack to the heap
            for index in 0..es.len() {
                let si_ = si + index as u32;
                instrs.push_str(&format!(
                    "
mov rbx, [rsp + {}]
mov [r15], rbx
add r15, 8",
                    si_ * 8
                ));
            }

            // get the address of the first element and plus 1 to indicate it's a tuple
            instrs.push_str(&format!(
                "
mov rax, rcx
add rax, 1"
            ));

            instrs
        }

        Expr::Index(tup_expr, num_expr) => {
            let mut instrs = String::new();

            let tup_instrs = compile_expr(tup_expr, si, env, fun_map, break_target, false, label);
            let num_instrs =
                compile_expr(num_expr, si + 1, env, fun_map, break_target, false, label);
            let tup_location = format!("[rsp + {}]", si * 8);

            instrs.push_str(&format!(
                "{tup_instrs}
mov {tup_location}, rax{num_instrs}"
            ));

            // check tuple and index type
            instrs.push_str(&check_is_tuple(&tup_location));
            instrs.push_str(&check_is_num("rax"));

            instrs.push_str(&format!(
                "
mov rcx, {tup_location}
mov rdx, rax"
            ));

            // preparation step
            instrs.push_str("\nsub rcx, 1");
            instrs.push_str("\nsar rdx, 1");

            // loop through the tuple to get the element at index
            let begin_label = new_label(label, "index_begin");
            let end_label = new_label(label, "index_end");
            instrs.push_str(&format!(
                "
cmp rdx, [rcx]
jge index_out_of_bound_error
add rcx, 8
{begin_label}:
cmp rdx, 0
je {end_label}
sub rdx, 1
add rcx, 8
jmp {begin_label}
{end_label}:
mov rax, [rcx]
mov rbx, rcx
and rbx, 3
cmp rbx, 1
cmove rax, rcx"
            ));

            instrs
        }

        Expr::FunCall(name, args) => match fun_map.clone().get(name) {
            Some((param_count, depth)) => {
                let arg_count = args.len() as u32;
                if *param_count != arg_count {
                    panic!("Invalid: calling functions with wrong number of arguments")
                }

                let mut instrs = String::new();
                let fun_label = format!("fun_{}", name);

                for (index, arg) in args.iter().enumerate() {
                    let si_ = si + index as u32;
                    let arg_instrs =
                        compile_expr(arg, si_, env, fun_map, break_target, false, label);
                    instrs.push_str(&arg_instrs);
                    instrs.push_str(&format!("\nmov [rsp + {}], rax", si_ * 8));
                }

                let offset_index = if *depth % 2 == 0 { *depth + 1 } else { *depth };
                let arg_index = si + offset_index;
                let offset = offset_index * 8;
                instrs.push_str(&format!("\nsub rsp, {offset}"));

                for index in 0..arg_count {
                    instrs.push_str(&format!(
                        "
mov rbx, [rsp + {}]
mov [rsp + {}], rbx",
                        (arg_index + index) * 8,
                        index * 8
                    ));
                }

                instrs.push_str(&format!(
                    "
call {fun_label}
add rsp, {offset}"
                ));

                instrs
            }
            None => panic!("Invalid: function does not exist or invalid expression"),
        },

        Expr::FunDef(_name, _params, _body) => {
            panic!("Invalid: cannot define function inside expression")
        }
    }
}

// Throw error if location_last_bit != last_bit
fn check_is_num(location: &str) -> String {
    format!(
        "
mov rbx, {location}
and rbx, 1
cmp rbx, 0
jne type_error"
    )
}

// Return location is a num
fn is_num(location: &str) -> String {
    format!(
        "
mov rcx, {location}
mov rax, 3
mov rbx, 7
and rcx, 1
cmp rcx, 0
cmove rax, rbx"
    )
}

// Return location is a bool
fn is_bool(location: &str) -> String {
    format!(
        "
mov rcx, {location}
mov rax, 3
mov rbx, 7
and rcx, 3
cmp rcx, 3
cmove rax, rbx"
    )
}

// Throw error if parameters don't have same type
fn check_both_type_same(e1_location: &str, e2_location: &str) -> String {
    format!(
        "
mov rbx, {e1_location}
xor rbx, {e2_location}
test rbx, 1
jnz type_error",
    )
}

// Throw error if parameters are not both num
fn check_both_type_same_num(e1_location: &str, e2_location: &str) -> String {
    format!(
        "
mov rbx, {e1_location}
or rbx, {e2_location}
and rbx, 1
test rbx, 1
jnz type_error",
    )
}

// Compute the correct cmp instructions
fn cmp_instrs(e1_location: &str, e2_location: &str, cmov_op: &str) -> String {
    format!(
        "
mov rcx, {e1_location}
mov rax, 3
mov rbx, 7
cmp rcx, {e2_location}
{cmov_op} rax, rbx"
    )
}

// Create a new label
fn new_label(label: &mut u32, s: &str) -> String {
    let current = *label;
    *label += 1;
    format!("{s}_{current}")
}

fn check_is_tuple(location: &str) -> String {
    format!(
        "
mov rbx, {location}
cmp rbx, 1
je type_error
and rbx, 3
cmp rbx, 1
jne type_error"
    )
}

// Get the depth of expression
fn depth(e: &Expr) -> u32 {
    match e {
        Expr::Number(_) => 0,
        Expr::Boolean(_) => 0,
        Expr::Id(_) => 0,
        Expr::UnOp(_, expr) => depth(expr),
        Expr::BinOp(_, expr1, expr2) => (depth(expr1) + 1).max(depth(expr2)),
        Expr::Let(binding, expr) => {
            let binding_depth = binding
                .iter()
                .enumerate()
                .map(|(index, (_, e))| depth(e) + index as u32)
                .max()
                .unwrap_or(0);
            binding_depth.max(depth(expr) + binding.len() as u32)
        }
        Expr::If(expr1, expr2, expr3) => depth(expr1).max(depth(expr2)).max(depth(expr3)),
        Expr::Loop(expr) => depth(expr),
        Expr::Block(exprs) => exprs.iter().map(|expr| depth(expr)).max().unwrap_or(0),
        Expr::Break(expr) => depth(expr),
        Expr::Set(_, expr) => depth(expr),
        Expr::Tuple(elements) => {
            let elements_depth = elements
                .iter()
                .enumerate()
                .map(|(index, expr)| depth(expr) + index as u32)
                .max()
                .unwrap_or(0);
            elements_depth.max(elements.len() as u32)
        }
        Expr::Index(tup_expr, num_expr) => depth(tup_expr).max(depth(num_expr) + 1),
        Expr::FunCall(_, args) => {
            let args_depth = args
                .iter()
                .enumerate()
                .map(|(index, expr)| depth(expr) + index as u32)
                .max()
                .unwrap_or(0);
            args_depth.max(args.len() as u32)
        }
        _ => panic!("not suppose to call depth"),
    }
}
