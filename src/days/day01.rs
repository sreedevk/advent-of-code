#![allow(unused, unused_imports)]

use crate::template::Solution;
use anyhow::Result;
use itertools::Itertools;
use regex::{Regex, RegexSet};
use tap::prelude::*;

pub struct Day01;

const DATA: &str = include_str!("../../data/day01.txt");
const EXAMPLE: &str = include_str!("../../data/day01_example.txt");

impl Solution for Day01 {
    fn solve_part1(&self) -> Result<String> {
        Ok(DATA
            .lines()
            .map(|line| {
                line.trim()
                    .chars()
                    .filter(|c| c.is_numeric())
                    .map(|c| c.to_digit(10).unwrap())
                    .collect::<Vec<u32>>()
            })
            .map(|n| (10 * n.first().unwrap()) + n.last().unwrap())
            .sum::<u32>()
            .to_string())
    }

    fn solve_part2(&self) -> Result<String> {
        let patterns = [
            "zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine", r"\d",
        ]
        .into_iter()
        .map(|pattern| Regex::new(pattern).unwrap())
        .collect::<Vec<Regex>>();

        let parse_int = |s: &str| -> u32 {
            match s {
                "one" => 1,
                "two" => 2,
                "three" => 3,
                "four" => 4,
                "five" => 5,
                "six" => 6,
                "seven" => 7,
                "eight" => 8,
                "nine" => 9,
                "zero" => 0,
                x => u32::from_str_radix(x, 10).unwrap(),
            }
        };

        Ok(DATA
            .lines()
            .map(|line| {
                patterns
                    .clone()
                    .iter()
                    .flat_map(|pattern| {
                        pattern
                            .find_iter(line.trim())
                            .map(move |m| (m.start(), m.as_str()))
                            .collect::<Vec<_>>()
                    })
                    .into_iter()
                    .sorted_by(|(i1, _), (i2, _)| i1.cmp(i2))
                    .map(|(_, s)| parse_int(s))
                    .collect::<Vec<u32>>()
            })
            .map(|n| (n.first().unwrap() * 10) + n.last().unwrap())
            .sum::<u32>()
            .to_string())
    }
}
