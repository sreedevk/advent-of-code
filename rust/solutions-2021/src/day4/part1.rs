#![allow(unused)]

use common::grid::rotate_cw;
use std::fs;

#[derive(Debug, Clone)]
pub struct Slot {
    pub num: usize,
    pub called: bool,
}

type Board = Vec<Vec<Slot>>;
type Calls = Vec<usize>;

pub fn solve() -> String {
    let (mut calls, mut boards) = parse_input();
    String::from("UNSOLVED")
}

pub fn has_won(board: &Board) -> bool {
    let rotated_board = rotate_cw(board.to_owned().to_vec());

    board
        .iter()
        .any(|slot_line| slot_line.iter().all(|slot| slot.called))
        || rotate_cw(rotated_board)
            .iter()
            .any(|slot_line| slot_line.iter().all(|slot| slot.called))
}

fn parse_boards(input: &str) -> Vec<Board> {
    input
        .trim()
        .split("\n\n")
        .map(parse_board)
        .collect()
}

fn parse_board(input: &str) -> Board {
    input
        .trim()
        .split('\n')
        .map(|line| {
            line.trim()
                .split(' ')
                .filter(|num| !num.is_empty())
                .map(|num| Slot {
                    num: num.trim().parse::<usize>().unwrap(),
                    called: false,
                })
                .collect()
        })
        .collect()
}

fn parse_calls(input: &str) -> Calls {
    input
        .trim()
        .split(',')
        .map(|char| char.trim())
        .map(|num| num.parse::<usize>().unwrap())
        .collect()
}

fn parse_input() -> (Calls, Vec<Board>) {
    let raw_data = fs::read_to_string("data/example/2021/day4.txt").expect("file_not_found");
    let (raw_calls, raw_boards) = raw_data.trim().split_once("\n\n").unwrap();
    let calls = parse_calls(raw_calls);
    let boards = parse_boards(raw_boards);

    (calls, boards)
}
