use itertools::Itertools;
use std::fs;

fn intersection((a, b): (&[usize], &[usize])) -> usize {
    *a.iter().find(|x| b.contains(x)).unwrap()
}

pub fn solve() -> String {
    let raw = fs::read_to_string("data/main/2022/day3.txt").unwrap();
    let priorities_sum = raw
        .trim()
        .split('\n')
        .into_iter()
        .map(|sack| sack.trim().chars())
        .map(|sack| sack.map(super::to_priority).collect_vec())
        .map(|x| intersection(x.split_at(x.len() / 2)))
        .sum::<usize>();

    format!("{}", priorities_sum)
}
