use std::{collections::HashSet, fs};
use itertools::Itertools;

fn to_priority(input: char) -> usize {
    if input.is_uppercase() {
        (input as usize) - 38
    } else {
        (input as usize) - 96
    }
}

fn intersection(a: Vec<usize>, b: Vec<usize>) -> usize {
    a.into_iter().find(|x| b.contains(x)).unwrap()
}

pub fn solve() -> String {
    let raw = fs::read_to_string("data/main/2022/day3.txt").unwrap();
    let priorities_sum = raw
        .trim()
        .split('\n')
        .into_iter()
        .map(|sack| sack.trim().chars().map(to_priority).collect::<Vec<usize>>())
        .collect::<Vec<Vec<usize>>>()
        .into_iter()
        .map(|x| {
            let (a, b) = x.split_at(x.len() / 2);
            intersection(a.to_owned(), b.to_owned())
        })
        .sum::<usize>();

        format!("{}", priorities_sum)
}
