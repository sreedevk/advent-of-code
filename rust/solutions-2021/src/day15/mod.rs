mod part1;
mod part2;

use std::fs;

pub struct Day15;

pub fn build_graph() {
    let raw_data = fs::read_to_string("data/examples/2021/day15.txt").expect("file_not_found");
    let map: Vec<Vec<u64>> = raw_data
        .trim()
        .split("\n")
        .map(|line| {
            line.chars()
                .map(|x| u64::from_str_radix(&x.to_string(), 10).unwrap_or_default())
                .collect()
        })
        .collect();

    dbg!(map);
}

impl Day15 {
    pub fn solve() -> [String; 2] {
        build_graph();
        [part1::solve(), part2::solve()]
    }
}
