use std::fs;

fn to_priority(input: char) -> usize {
    if input.is_uppercase() {
        (input as usize) - 38
    } else {
        (input as usize) - 96
    }
}

fn intersection((a, b): (&[usize], &[usize])) -> usize {
    *a.into_iter().find(|x| b.contains(x)).unwrap()
}

pub fn solve() -> String {
    let raw = fs::read_to_string("data/main/2022/day3.txt").unwrap();
    let priorities_sum = raw
        .trim()
        .split('\n')
        .into_iter()
        .map(|sack| sack.trim().chars().map(to_priority).collect::<Vec<usize>>())
        .map(|x| intersection(x.split_at(x.len() / 2)))
        .sum::<usize>();

    format!("{}", priorities_sum)
}
