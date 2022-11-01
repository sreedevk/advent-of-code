mod parser;
mod expression;

use std::fs;
use std::collections::HashMap;

pub type Circuit = HashMap<String, u16>;
pub struct Day7;

impl Day7 {
    pub fn solve() -> [String; 2] {
        [
            Self::solve1(),
            String::from("test2")
        ]
    }

    fn solve1() -> String {
        let source = Self::read_file("data/example/2015/day7.txt");
        let parsed = source
            .iter()
            .map(|x| parser::parse_expr(x).unwrap() )
            .map(|(_x, y)| y )
            .fold(Circuit::new(), |crc, x| { x.eval(crc) } );

        format!("{:?}", parsed)
    }

    fn read_file(path: &str) -> Vec<String> {
        fs::read_to_string(path)
            .expect("InvalidFile")
            .trim()
            .split("\n")
            .map(String::from)
            .collect()
    }
}
