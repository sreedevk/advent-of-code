use anyhow::Result;

use crate::template::Solution;

mod part1;
mod part2;

const DATA: &str = include_str!("../../../data/day03.txt");

pub struct Day03;

pub fn to_priority(input: char) -> usize {
    if input.is_uppercase() {
        (input as usize) - 38
    } else {
        (input as usize) - 96
    }
}

impl Solution for Day03 {
    fn solve_part1(&self) -> Result<String> {
        Ok(part1::solve(DATA))
    }

    fn solve_part2(&self) -> Result<String> {
        Ok(part2::solve(DATA))
    }
}
