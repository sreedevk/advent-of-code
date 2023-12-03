pub struct Day01;
use itertools::Itertools;
use anyhow::Result;

use crate::template::Solution;

const DATA: &str = include_str!("../../../data/day01.txt");

impl Solution for Day01 {
    fn solve_part1(&self) -> Result<String> {
        let solution = DATA
            .trim()
            .split("\n\n")
            .map(|elf| {
                elf.split('\n')
                    .map(|meal| meal.trim().parse::<usize>().unwrap())
                    .sum::<usize>()
            })
            .max()
            .unwrap();

        Ok(solution.to_string())
    }

    fn solve_part2(&self) -> Result<String> {
        let solution = DATA
            .trim()
            .split("\n\n")
            .map(|elf| {
                elf.split('\n')
                    .map(|meal| meal.trim().parse::<usize>().unwrap())
                    .sum::<usize>()
            })
            .sorted()
            .rev()
            .take(3)
            .sum::<usize>();

        Ok(solution.to_string())
    }
}
