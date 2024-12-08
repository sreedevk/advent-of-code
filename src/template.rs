use anyhow::Result;

pub trait Solution {
    fn solve_part1(&self) -> Result<String>;
    fn solve_part2(&self) -> Result<String>;
}
