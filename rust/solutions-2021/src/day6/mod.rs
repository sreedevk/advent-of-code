mod part1;
mod part2;
use std::collections::HashMap;

pub struct Day6;
pub type FishCounter = HashMap<usize, usize>;

impl Day6 {
    pub fn solve() -> [String; 2] {
        [part1::solve(), part2::solve()]
    }
}
