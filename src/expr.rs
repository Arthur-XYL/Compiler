#[derive(Debug)]
pub enum Expr {
    Number(i64),
    Boolean(bool),
    Id(String),
    Let(Vec<(String, Expr)>, Box<Expr>),
    UnOp(Op1, Box<Expr>),
    BinOp(Op2, Box<Expr>, Box<Expr>),
    If(Box<Expr>, Box<Expr>, Box<Expr>),
    Loop(Box<Expr>),
    Break(Box<Expr>),
    Set(String, Box<Expr>),
    Block(Vec<Expr>),
    Tuple(Vec<Expr>),
    Index(Box<Expr>, Box<Expr>),
    FunDef(String, Vec<String>, Box<Expr>),
    FunCall(String, Vec<Expr>),
}

#[derive(Debug)]
pub enum Op1 {
    Add1,
    Sub1,
    IsNum,
    IsBool,
    Print,
}

#[derive(Debug)]
pub enum Op2 {
    Plus,
    Minus,
    Times,
    Equal,
    Greater,
    GreaterEqual,
    Less,
    LessEqual,
}
