use std::collections::{HashMap, HashSet};
use std::fs;

type CaveMap<'a> = HashMap<&'a str, Vec<&'a str>>;

fn build_cavemap<'a>(raw_data: Vec<&'a str>) -> CaveMap<'a> {
    let mut cave_map = CaveMap::new();
    raw_data.iter().for_each(|map_part| {
        let (from, to) = map_part.split_once("-").unwrap();

        cave_map.entry(from).or_insert(vec![]).push(to);

        cave_map.entry(to).or_insert(vec![]).push(from);
    });

    dbg!(&cave_map);
    cave_map
}

fn count_paths<'a>(
    map: &CaveMap,
    position: &'a str,
    visited: &mut HashSet<&'a str>,
    paths_count: &mut usize,
) {
    if position == String::from("end") {
        *paths_count += 1;
        return;
    }

    visited.insert(position);
    if let Some(paths) = map.get(position) {
        for path in paths {
            if is_lowercase(path) && visited.contains(path) {
                continue;
            } else {
                count_paths(map, path, &mut visited.clone(), paths_count)
            }
        }
    }
}

fn is_lowercase(node: &str) -> bool {
    node.chars().all(|chr| chr.is_ascii_lowercase())
}

pub fn solve() -> String {
    let raw_data: String =
        fs::read_to_string("data/main/2021/day12.txt").expect("input data not found");
    let raw_data_lines: Vec<&str> = raw_data
        .trim()
        .split("\n")
        .map(|line| line.trim())
        .collect();

    let cave_map: CaveMap = build_cavemap(raw_data_lines);
    let mut visited_set: HashSet<&str> = HashSet::new();
    let mut paths_count = 0usize;

    count_paths(&cave_map, "start", &mut visited_set, &mut paths_count);
    String::from(format!("{}", paths_count))
}
