#![allow(unused)]
#![feature(slice_take)]

use std::str;

use nom::{
    branch::alt,
    bytes::complete::{is_a, tag, take_while},
    character::complete::{alpha0, digit0, space0},
    combinator::map,
    sequence::tuple,
    Finish, IResult,
};
use std::char;
use std::io::BufRead;

use itertools::Itertools;

#[derive(Debug)]
struct Instruction {
    pub from: usize,
    pub to: usize,
    pub count: usize,
}

fn lex_instruction(raw: &str) -> IResult<&str, Instruction> {
    map(
        tuple((
            tag("move"),
            space0,
            digit0,
            space0,
            tag("from"),
            space0,
            digit0,
            space0,
            tag("to"),
            space0,
            digit0,
        )),
        parse_instruction,
    )(raw)
}

fn parse_instruction(
    (_, _, count, _, _, _, from, _, _, _, to): (
        &str,
        &str,
        &str,
        &str,
        &str,
        &str,
        &str,
        &str,
        &str,
        &str,
        &str,
    ),
) -> Instruction {
    Instruction {
        from: from.parse::<usize>().unwrap(),
        to: to.parse::<usize>().unwrap(),
        count: count.parse::<usize>().unwrap(),
    }
}

fn gen_instructions(raw: &str) -> Vec<Instruction> {
    raw.trim()
        .split('\n')
        .map(|line| line.trim())
        .map(lex_instruction)
        .map(|result| match result {
            Ok((_, x)) => x,
            Err(_) => panic!("Invalid Instruction"),
        })
        .collect()
}

fn process_instruction(i: Instruction, crates: Vec<Vec<String>>) -> Vec<Vec<String>> {
    let mut new_crates = crates.clone();
    let (kept, removed) = crates[i.from - 1].split_at(crates[i.from - 1].len() - i.count);
    new_crates[i.from - 1] = kept.to_vec();
    new_crates[i.to - 1].extend(removed.to_vec());
    new_crates
}

fn gen_crates(raw: &str) -> Vec<Vec<String>> {
    let columns = raw
        .split('\n')
        .map(|line| {
            line.as_bytes()
                .chunks(4)
                .map(str::from_utf8)
                .map(|v| v.unwrap().trim().to_string())
                .collect_vec()
        })
        .collect_vec();

    let (indices, boxes) = columns.split_last().unwrap();
    (0..indices.len())
        .map(|index| {
            boxes
                .into_iter()
                .map(|bx| bx[index].clone())
                .filter(|k| !k.is_empty())
                .rev()
                .collect_vec()
        })
        .collect_vec()
}

pub fn solve(raw: &str) -> String {
    let (raw_crates, raw_instructions) = raw.split_once("\n\n").unwrap();
    let result: Vec<Vec<String>> = gen_instructions(raw_instructions)
        .into_iter()
        .fold(gen_crates(raw_crates), |acc, instr| {
            process_instruction(instr, acc)
        });

    format!(
        "{:?}",
        result
            .into_iter()
            .map(|x| x.last().unwrap().clone())
            .collect_vec()
    )
}
