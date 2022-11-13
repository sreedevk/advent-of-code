use super::{build_cavemap, is_lowercase, CaveMap};
use std::collections::HashSet;
use std::fs;

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
