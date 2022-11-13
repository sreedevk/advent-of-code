#![allow(dead_code)]

pub struct Day12 {}

mod part1;
mod part2;

impl Day12 {
    pub fn solve() -> [String; 2] {
        [part1::solve(), Self::solve2()]
    }

    pub fn solve2() -> String {
        String::from("UNSOLVED")
    }
}
