pub mod day01;
pub mod day02;
pub mod day03;
pub mod day04;
pub mod day05;
pub mod day06;
pub mod day07;
pub mod day10;

use crate::template::Solution;

pub fn fetch(day: u32) -> Box<dyn Solution + 'static> {
    match day {
        1 => Box::new(day01::Day01),
        2 => Box::new(day02::Day02),
        3 => Box::new(day03::Day03),
        4 => Box::new(day04::Day04),
        5 => Box::new(day05::Day05),
        6 => Box::new(day06::Day06),
        7 => Box::new(day07::Day07),
        10 => Box::new(day10::Day10),
        _ => panic!("Day {} not implemented", day),
    }
}
