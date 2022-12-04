use itertools::Itertools;
use std::fs;

fn rangeize(elf: &str) -> (usize, usize) {
    let (low, high) = elf.split('-').collect_tuple().unwrap();
    (low.parse::<usize>().unwrap(), high.parse::<usize>().unwrap())
}

fn covers(a: (usize, usize), b: (usize, usize)) -> bool {
    let (amin, amax) = a;
    let (bmin, bmax) = b;

    (amin <= bmin && amax >= bmax) || (bmin <= amin && bmax >= amax)
}

pub fn solve() -> String {
    let raw = fs::read_to_string("data/main/2022/day4.txt").unwrap();
    let solution = raw
        .trim()
        .split('\n')
        .map(|elves| elves.trim().split(',').collect_tuple().unwrap())
        .map(|(elf1, elf2)| (rangeize(elf1), rangeize(elf2)))
        .filter(|(elf1, elf2)| covers(elf1.to_owned(), elf2.to_owned()))
        .count();

    format!("{}", solution)
}
