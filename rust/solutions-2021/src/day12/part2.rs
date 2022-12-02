use super::{build_cavemap, is_lowercase, CaveMap};
use std::{collections::HashMap, fs};

fn has_repeats(set: &[&str]) -> bool {
    let mut freq: HashMap<&str, usize> = HashMap::new();
    for item in set.iter().filter(|x| is_lowercase(x)) {
        freq.entry(item)
            .and_modify(|count| *count += 1)
            .or_insert(1);
    }

    freq.values().any(|val| *val >= 2)
}

fn count_paths<'a>(
    map: &CaveMap,
    position: &'a str,
    visited: &mut Vec<&'a str>,
    paths_count: &mut usize,
) {
    if position == "end" {
        *paths_count += 1;
        return;
    }

    visited.push(position);

    if let Some(paths) = map.get(position) {
        for path in paths {
            match *path {
                "start" => continue,
                cpath if is_lowercase(cpath) && visited.contains(&cpath) => {
                    if has_repeats(visited) {
                        continue
                    }
                    else {
                        count_paths(map, path, &mut visited.clone(), paths_count)
                    }
                },
                _ => count_paths(map, path, &mut visited.clone(), paths_count)
            }
        }
    }
}

pub fn solve() -> String {
    let raw_data: String =
        fs::read_to_string("data/main/2021/day12.txt").expect("input data not found");

    let raw_data_lines: Vec<&str> = raw_data
        .trim()
        .split('\n')
        .map(|line| line.trim())
        .collect();

    let cavemap = build_cavemap(raw_data_lines);
    let mut visited: Vec<&str> = Vec::new();
    let mut paths_count: usize = 0;

    count_paths(&cavemap, "start", &mut visited, &mut paths_count);
    format!("{}", paths_count)
}
