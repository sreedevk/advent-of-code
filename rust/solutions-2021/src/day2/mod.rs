mod part1;
mod part2;
use common::*;
use part1::Part1;
use part2::Part2;

pub struct Day2;

impl Day2 {
    pub fn solve() -> [String; 2] {
        [
            Day2::solve1(),
            Day2::solve2(),
        ]
    }

    fn solve1() -> String {
        let solution = Part1::solve(file_manager::read("data/main/2021/day2.txt").as_str());
        return String::from(format!("{}", solution));
    }

    fn solve2() -> String {
        let solution = Part2::solve(file_manager::read("data/main/2021/day2.txt").as_str());
        return String::from(format!("{}", solution));
    }
}
