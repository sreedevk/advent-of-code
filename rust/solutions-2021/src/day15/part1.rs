#![allow(unused)]

use std::cmp::Reverse;
use std::collections::{BTreeMap, BinaryHeap};
use std::fs;
use std::ops::Add;

type Graph<V, E> = BTreeMap<V, BTreeMap<V, E>>;

pub fn load_matrix() -> Vec<Vec<u32>> {
    let raw_data = fs::read_to_string("data/example/2021/day15.txt").expect("file_not_found");
    
    raw_data
        .trim()
        .split("\n")
        .map(|line| {
            line.chars()
                .map(|cell| u32::from_str_radix(&cell.to_string(), 10).unwrap())
                .collect()
        })
        .collect()
}

pub fn solve() -> String {
    String::from("UNSOLVED")
}
