use itertools::Itertools;
use std::{collections::HashSet, fs};

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

fn three_way(a: Vec<usize>, b: Vec<usize>, c: Vec<usize>) -> usize {
    a.into_iter()
        .find(|x| b.contains(x) && c.contains(x))
        .unwrap()
}

pub fn solve() -> String {
    let raw = fs::read_to_string("data/main/2022/day3.txt").unwrap();
    let priorities_sum = raw
        .trim()
        .split('\n')
        .map(|sack| sack.trim().chars().map(to_priority).collect::<Vec<usize>>())
        .chunks(3)
        .into_iter()
        .map(|chunk| {
            let elfchunk = chunk.collect_vec();
            three_way(elfchunk[0].to_owned(), elfchunk[1].to_owned(), elfchunk[2].to_owned())
        })
        .sum::<usize>();

    format!("{}", priorities_sum)
}
