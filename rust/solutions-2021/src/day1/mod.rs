pub struct Day1;
use common::*;

impl Day1 {
    pub fn solve() -> [String; 2] {
        [
            Day1::solve1(),
            Day1::solve2(),
        ]
    }

    fn solve1() -> String {
        let solution = file_manager::readlines("data/main/2021/day1.txt")
            .into_iter()
            .map(|input| input.parse().unwrap() )
            .collect::<Vec<i32>>()
            .windows(2)
            .map(|input| input[1] > input[0] )
            .filter(|input| *input )
            .count();

        format!("{}", solution)
    }

    fn solve2() -> String {
        let solution = file_manager::readlines("data/main/2021/day1.txt")
            .into_iter()
            .map(|input| input.parse().unwrap() )
            .collect::<Vec<i32>>()
            .windows(3)
            .map( |input| input.iter().sum() )
            .collect::<Vec<i32>>()
            .windows(2)
            .map( |input| input[1] > input[0] )
            .filter( |input| *input )
            .count();

        format!("{}", solution)
    }
}
