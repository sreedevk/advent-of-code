use itertools::Itertools;
use std::fs;

fn all_unique(chrs: Vec<char>) -> bool {
    chrs == chrs.clone().into_iter().unique().collect_vec()
}

pub fn solve() -> String {
    let raw = fs::read_to_string("data/main/2022/day6.txt").unwrap();
    let init = raw
        .chars()
        .collect_vec();

    let results = init
        .windows(14)
        .into_iter()
        .enumerate()
        .take_while(|(_, chars)| !all_unique(chars.to_vec()) )
        .collect_vec();

    let (result, _) = results.last().unwrap();
    format!("{}", result + 15)
}

