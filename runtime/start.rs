use std::env;

#[link(name = "our_code")]
extern "C" {
    // The \x01 here is an undocumented feature of LLVM that ensures
    // it does not add an underscore in front of the name.
    // Courtesy of Max New (https://maxsnew.com/teaching/eecs-483-fa22/hw_adder_assignment.html)
    #[link_name = "\x01our_code_starts_here"]
    fn our_code_starts_here(input: i64, heap_address: *mut i64) -> i64;
}

#[export_name = "\x01snek_print"]
pub extern "C" fn snek_print(val: i64) -> i64 {
    let mut seen = Vec::<i64>::new();
    println!("{}", snek_str(val, &mut seen));
    return val;
}

fn snek_str(val: i64, seen: &mut Vec<i64>) -> String {
    if val == 7 {
        "true".to_string()
    } else if val == 3 {
        "false".to_string()
    } else if val == 1 {
        "nil".to_string()
    } else if val % 2 == 0 {
        format!("{}", val >> 1)
    } else if val & 1 == 1 {
        if seen.contains(&val) {
            return "(tuple <cyclic>)".to_string();
        }
        seen.push(val);
        let addr = (val - 1) as *const i64;
        let length = unsafe { *addr };

        let mut result = String::new();
        result.push_str("(tuple ");
        for index in 1..length {
            let element = unsafe { *addr.offset(index as isize) };
            result.push_str(&format!("{} ", snek_str(element, seen)));
        }
        let element = unsafe { *addr.offset(length as isize) };
        result.push_str(&format!("{})", snek_str(element, seen)));

        seen.pop();
        return result;
    } else {
        format!("Unknown value: {}", val)
    }
}

#[export_name = "\x01snek_error"]
pub extern "C" fn snek_error(errcode: i64) -> ! {  // Note the `-> !` return type
    let msg = match errcode {
        1 => "invalid argument: type error",
        2 => "arithmetic overflow",
        3 => "index out of bounds",
        _ => "unknown runtime error",
    };
    eprintln!("Runtime error: {msg}");
    std::process::exit(1);  // Immediate termination
}

fn parse_input(input: &str) -> i64 {
    if input == "true" {
        7
    } else if input == "false" {
        3
    } else {
        let input_pre = input
            .parse::<i64>()
            .unwrap_or_else(|_| panic!("Invalid input"));
        if input_pre > 4611686018427387903 || input_pre < -4611686018427387904 {
            panic!("Invalid input: overflowing")
        }
        input_pre << 1
    }
}

fn main() {
    let args: Vec<String> = env::args().collect();
    let input = if args.len() == 2 { &args[1] } else { "false" };
    let input = parse_input(&input);

    let mut memory = Vec::<i64>::with_capacity(1000000);
    let buffer: *mut i64 = memory.as_mut_ptr();
    let i: i64 = unsafe { our_code_starts_here(input, buffer) };
    snek_print(i);
}
