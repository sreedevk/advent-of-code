use crate::template::Solution;
use anyhow::Result;

mod part1;
mod part2;
pub struct Day07;

const DATA: &str = include_str!("../../../data/day07.txt");

impl Solution for Day07 {
    fn solve_part1(&self) -> Result<String> {
        Ok(part1::solve(DATA))
    }

    fn solve_part2(&self) -> Result<String> {
        Ok(part2::solve(DATA))
    }
}
