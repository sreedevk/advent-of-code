use super::{build_cavemap, is_lowercase, CaveMap};
use std::{
    collections::{HashMap, HashSet},
    fs,
};

fn has_repeats(set: &HashSet<&str>) -> bool {
    let mut freq: HashMap<&str, usize> = HashMap::new();
    for item in set.iter().filter(|x| is_lowercase(x)) {
        freq.entry(item)
            .and_modify(|count| *count += 1)
            .or_insert(0);
    }
    if freq.values().any(|val| *val == 1) {
        true
    } else {
        false
    }
}

fn count_paths<'a>(
    map: &CaveMap,
    position: &'a str,
    visited: &mut HashSet<&'a str>,
    paths_count: &mut usize,
) {
    if position == "end" {
        *paths_count += 1;
        return;
    }

    visited.insert(position);

    if let Some(paths) = map.get(position) {
        for path in paths {
            if is_lowercase(path) && has_repeats(visited) {
                continue;
            } else {
                count_paths(map, path, &mut visited.clone(), paths_count)
            }
        }
    }
}

pub fn solve() -> String {
    let raw_data: String =
        fs::read_to_string("data/example/2021/day12.txt").expect("input data not found");

    let raw_data_lines: Vec<&str> = raw_data
        .trim()
        .split("\n")
        .map(|line| line.trim())
        .collect();

    let cavemap = build_cavemap(raw_data_lines);
    let mut visited: HashSet<&str> = HashSet::new();
    let mut paths_count: usize = 0;

    count_paths(&cavemap, "start", &mut visited, &mut paths_count);

    String::from(format!("{}", paths_count))
}
