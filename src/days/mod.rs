pub mod day01;

use crate::template::Solution;

pub fn fetch(day: u32) -> impl Solution {
    match day {
        1 => day01::Day01,
        _ => panic!("Day {} not implemented", day),
    }
}
