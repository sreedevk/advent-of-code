use std::fs;
use itertools::Itertools;

fn all_unique(chrs: Vec<char>) -> bool {
    chrs == chrs.clone().into_iter().unique().collect_vec()
}

pub fn solve() -> String {
    let raw = fs::read_to_string("data/main/2022/day6.txt").unwrap();
    let results = raw
        .chars()
        .collect_vec()
        .windows(4)
        .into_iter()
        .enumerate()
        .filter_map(|(index, chars)| { if all_unique(chars.to_vec()) { Some(index + 4) } else { None } })
        .collect_vec();

    format!("{}", results.get(0).unwrap())
}
