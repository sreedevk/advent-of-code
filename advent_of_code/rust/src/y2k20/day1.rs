use std::fs;
use itertools::*;

pub fn solve_alpha() {
    let file = fs::read_to_string("data/2020/day1.txt").expect("Unable to read datafile");
    let data: Vec<&str> = file
        .split("\n")
        .collect();

    let parsed_data: Vec<i32> = data
        .iter()
        .map(|var| var.parse::<i32>().unwrap() )
        .collect();

    parsed_data
        .iter()
        .filter(|var| parsed_data.contains(*var - 2020) );
}
