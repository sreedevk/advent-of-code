pub struct Day3;
use common::*;

impl Day3 {
    pub fn solve() -> [String; 2] {
        [
            Day3::solve1(),
            Day3::solve2(),
        ]
    }

    fn solve1() -> String {
        let solution = FileManager::readlines("data/main/2021/day3.txt")
            .into_iter()
            .map(|input| input.parse().unwrap() )
            .collect::<Vec<i32>>()
            .windows(2)
            .map(|input| input[1] > input[0] )
            .filter(|input| *input )
            .collect::<Vec<bool>>()
            .len();

        return String::from(format!("{}", solution));
    }

    fn solve2() -> String {
        let solution = FileManager::readlines("data/main/2021/day3.txt")
            .into_iter()
            .map(|input| input.parse().unwrap() )
            .collect::<Vec<i32>>()
            .windows(3)
            .map( |input| input.iter().sum() )
            .collect::<Vec<i32>>()
            .windows(2)
            .map( |input| input[1] > input[0] )
            .filter( |input| *input )
            .collect::<Vec<bool>>()
            .len();

        return String::from(format!("{}", solution));
    }
}
