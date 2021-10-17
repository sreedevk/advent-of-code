mod y2k20;
use std::env;

fn main() {
    let args: Vec<String> = env::args().collect();
    match args[1].as_str() {
        _ => panic!("INVALID INSTR")
    }
}
