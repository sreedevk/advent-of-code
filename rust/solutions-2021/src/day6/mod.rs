use common::Solution;
use std::{collections::HashMap, fs};

pub struct Day6;
type FishCounter = HashMap<u16, usize>;

impl Solution for Day6 {
    fn solve() -> [String; 2] {
        [Self::solve1(), String::from("2021")]
    }
}

impl Day6 {
    fn tally(fishes: Vec<u16>) -> HashMap<u16, usize> {
        fishes.into_iter().fold(FishCounter::new(), |mut c, item| {
            c.entry(item).and_modify(|x| *x += 1).or_insert(1);
            c
        })
    }

    fn solve1() -> String {
        let data = fs::read_to_string("data/example/2021/day6.txt").expect("file not found!");
        let fishes = data
            .trim()
            .split(",")
            .map(|x| x.trim())
            .map(|x| u16::from_str_radix(x, 10).unwrap())
            .collect::<Vec<u16>>();

        String::from("test")
    }
}
