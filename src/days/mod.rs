pub mod day01;
pub mod day02;
pub mod day03;
pub mod day04;

use crate::template::Solution;

pub fn fetch(day: u32) -> Box<dyn Solution + 'static> {
    match day {
        1 => Box::new(day01::Day01),
        2 => Box::new(day02::Day02),
        3 => Box::new(day03::Day03),
        4 => Box::new(day04::Day04),
        _ => panic!("Day {} not implemented", day),
    }
}
