#![allow(dead_code)]

pub struct Day12 {}

mod part1;
mod part2;

use std::collections::HashMap;
pub type CaveMap<'a> = HashMap<&'a str, Vec<&'a str>>;

pub fn build_cavemap(raw_data: Vec<&str>) -> CaveMap<'_> {
    let mut cave_map = CaveMap::new();
    raw_data.iter().for_each(|map_part| {
        let (from, to) = map_part.split_once('-').unwrap();

        cave_map.entry(from).or_insert(vec![]).push(to);
        cave_map.entry(to).or_insert(vec![]).push(from);
    });

    cave_map
}

pub fn is_lowercase(node: &str) -> bool {
    node.chars().all(|chr| chr.is_ascii_lowercase())
}

impl Day12 {
    pub fn solve() -> [String; 2] {
        [part1::solve(), part2::solve()]
    }
}
