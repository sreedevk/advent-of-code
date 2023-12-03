mod part1;
mod part2;

use crate::template::Solution;
use anyhow::Result;

const DATA: &str = include_str!("../../../data/day02.txt");

pub struct Day02;

impl Solution for Day02 {
    fn solve_part1(&self) -> Result<String> {
        Ok(part1::solve(DATA))
    }

    fn solve_part2(&self) -> Result<String> {
        Ok(part2::solve(DATA))
    }
}
