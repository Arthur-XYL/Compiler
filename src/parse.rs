use sexp::Atom::*;
use sexp::*;

use crate::expr::Expr;
use crate::expr::Op1;
use crate::expr::Op2;

pub fn parse_exprs(s: &str) -> Vec<Expr> {
    let mut exprs = Vec::new();
    let mut start_index = 0;
    let mut open_parens = 0;
    let mut is_single_value = true;

    for (i, c) in s.chars().enumerate() {
        match c {
            '(' => {
                open_parens += 1;
                is_single_value = false;
            }
            ')' => {
                open_parens -= 1;
                if open_parens == 0 {
                    let sexp_str = &s[start_index..=i];
                    let sexp = parse(sexp_str).expect("Invalid expression");
                    exprs.push(parse_expr(&sexp));
                    start_index = i + 1;
                }
            }
            _ => (),
        }
    }

    if is_single_value {
        let sexp = parse(s).expect("Invalid expression");
        exprs.push(parse_expr(&sexp));
    }

    exprs
}

fn parse_expr(s: &Sexp) -> Expr {
    match s {
        Sexp::Atom(I(n)) => {
            // need to check overflow
            Expr::Number(
                i64::try_from(*n).unwrap_or_else(|_| panic!("Invalid: overflow integer value")),
            )
        }
        Sexp::Atom(S(n)) => {
            if n == "true" {
                Expr::Boolean(true)
            } else if n == "false" {
                Expr::Boolean(false)
            } else {
                Expr::Id(n.to_string())
            }
        }
        Sexp::List(vec) => match &vec[..] {
            [Sexp::Atom(S(ex)), Sexp::List(binding), e] if ex == "let" => {
                if binding.is_empty() {
                    panic!("Invalid: let no binding");
                }
                let mut vec = Vec::new();
                for x in binding {
                    vec.push(parse_bind(x));
                }
                Expr::Let(vec, Box::new(parse_expr(e)))
            }
            [Sexp::Atom(S(op1)), e] if op1 == "add1" => {
                Expr::UnOp(Op1::Add1, Box::new(parse_expr(e)))
            }
            [Sexp::Atom(S(op1)), e] if op1 == "sub1" => {
                Expr::UnOp(Op1::Sub1, Box::new(parse_expr(e)))
            }
            [Sexp::Atom(S(op1)), e] if op1 == "isnum" => {
                Expr::UnOp(Op1::IsNum, Box::new(parse_expr(e)))
            }
            [Sexp::Atom(S(op1)), e] if op1 == "isbool" => {
                Expr::UnOp(Op1::IsBool, Box::new(parse_expr(e)))
            }
            [Sexp::Atom(S(op1)), e] if op1 == "print" => {
                Expr::UnOp(Op1::Print, Box::new(parse_expr(e)))
            }
            [Sexp::Atom(S(op2)), e1, e2] if op2 == "+" => Expr::BinOp(
                Op2::Plus,
                Box::new(parse_expr(e1)),
                Box::new(parse_expr(e2)),
            ),
            [Sexp::Atom(S(op2)), e1, e2] if op2 == "-" => Expr::BinOp(
                Op2::Minus,
                Box::new(parse_expr(e1)),
                Box::new(parse_expr(e2)),
            ),
            [Sexp::Atom(S(op2)), e1, e2] if op2 == "*" => Expr::BinOp(
                Op2::Times,
                Box::new(parse_expr(e1)),
                Box::new(parse_expr(e2)),
            ),
            [Sexp::Atom(S(op2)), e1, e2] if op2 == "=" => Expr::BinOp(
                Op2::Equal,
                Box::new(parse_expr(e1)),
                Box::new(parse_expr(e2)),
            ),
            [Sexp::Atom(S(op2)), e1, e2] if op2 == ">" => Expr::BinOp(
                Op2::Greater,
                Box::new(parse_expr(e1)),
                Box::new(parse_expr(e2)),
            ),
            [Sexp::Atom(S(op2)), e1, e2] if op2 == ">=" => Expr::BinOp(
                Op2::GreaterEqual,
                Box::new(parse_expr(e1)),
                Box::new(parse_expr(e2)),
            ),
            [Sexp::Atom(S(op2)), e1, e2] if op2 == "<" => Expr::BinOp(
                Op2::Less,
                Box::new(parse_expr(e1)),
                Box::new(parse_expr(e2)),
            ),
            [Sexp::Atom(S(op2)), e1, e2] if op2 == "<=" => Expr::BinOp(
                Op2::LessEqual,
                Box::new(parse_expr(e1)),
                Box::new(parse_expr(e2)),
            ),
            [Sexp::Atom(S(ex)), e1, e2] if ex == "set!" => {
                Expr::Set(e1.to_string(), Box::new(parse_expr(e2)))
            }

            [Sexp::Atom(S(ex)), cond, e1, e2] if ex == "if" => Expr::If(
                Box::new(parse_expr(cond)),
                Box::new(parse_expr(e1)),
                Box::new(parse_expr(e2)),
            ),
            [Sexp::Atom(S(ex)), es @ ..] if ex == "block" => {
                let mut exprs = Vec::new();
                if es.len() == 0 {
                    panic!("Invalid: empty block")
                }

                for e in es {
                    exprs.push(parse_expr(e));
                }
                Expr::Block(exprs)
            }
            [Sexp::Atom(S(ex)), e] if ex == "loop" => Expr::Loop(Box::new(parse_expr(e))),
            [Sexp::Atom(S(ex)), e] if ex == "break" => Expr::Break(Box::new(parse_expr(e))),
            [Sexp::Atom(S(ex)), es @ ..] if ex == "tuple" => {
                let mut exprs = Vec::new();
                if es.len() == 0 {
                    panic!("Invalid: empty tuple")
                }

                for e in es {
                    exprs.push(parse_expr(e));
                }
                Expr::Tuple(exprs)
            }
            [Sexp::Atom(S(ex)), e1, e2] if ex == "index" => {
                Expr::Index(Box::new(parse_expr(e1)), Box::new(parse_expr(e2)))
            }
            [Sexp::Atom(S(fun)), Sexp::List(name_params), e] if fun == "fun" => {
                let (name, params) = match name_params.split_first() {
                    Some((Sexp::Atom(S(name)), rest)) if !is_keywords(name.clone()) => {
                        (name.clone(), rest.to_vec())
                    }
                    _ => panic!("Invalid expression: {:?}", name_params),
                };

                let params = params
                    .into_iter()
                    .map(|param| match param {
                        Sexp::Atom(S(param_name)) if !is_keywords(param_name.clone()) => {
                            param_name.clone()
                        }
                        _ => panic!("Invalid parameter name: {:?}", param),
                    })
                    .collect();

                Expr::FunDef(name, params, Box::new(parse_expr(e)))
            }
            [Sexp::Atom(S(fun_name)), es @ ..] => {
                if is_keywords(fun_name.clone()) {
                    panic!("Invalid: does not match to any operation")
                }

                let mut args = Vec::new();
                for e in es {
                    args.push(parse_expr(e));
                }
                Expr::FunCall(fun_name.clone(), args)
            }
            _ => panic!("Invalid: does not match to any operation"),
        },
        _ => panic!("Invalid: does not match to any Sexp"),
    }
}

fn parse_bind(s: &Sexp) -> (String, Expr) {
    match s {
        Sexp::List(vec) if vec.len() == 2 => {
            let name = match &vec[0] {
                Sexp::Atom(S(n)) => {
                    if is_keywords(n.to_string()) {
                        panic!("Invalid: using keyword as id");
                    }
                    n.to_string()
                }
                _ => panic!("Invalid: expected identifier"),
            };
            let value = parse_expr(&vec[1]);
            (name, value)
        }
        _ => panic!("Invalid: expected let-binding"),
    }
}

fn is_keywords(s: String) -> bool {
    let keywords = vec![
        "if", "loop", "break", "set!", "block", "true", "false", "let", "input", "tuple", "index",
        "print", "+", "-", "*", "=", ">", ">=", "<", "<=",
    ];
    for keyword in keywords {
        if s == *keyword {
            return true;
        }
    }
    return false;
}
