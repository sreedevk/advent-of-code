#![allow(unused)]
#![feature(slice_take)]

use nom::{
    branch::alt,
    bytes::complete::{tag, is_a, take_while},
    character::complete::{alpha0, digit0, space0},
    combinator::map,
    sequence::tuple, Finish,
    IResult
};
use std::char;
use std::fs;
use std::io::BufRead;

use itertools::Itertools;

#[derive(Debug, Clone)]
struct Crate<'a> {
    pub id: usize,
    pub boxes: Vec<&'a str>,
}

#[derive(Debug)]
struct Instruction {
    pub from: usize,
    pub to: usize,
    pub count: usize,
}

fn parse_crate<'a>(id: &str, boxes: Vec<&'a str>) -> Crate<'a> {
    Crate {
        id: id.trim().parse::<usize>().unwrap(),
        boxes: boxes
            .into_iter()
            .filter(|crt| !crt.chars().all(char::is_whitespace))
            .collect(),
    }
}

fn parse_possible_crate(raw: &str) -> IResult<&str, Option<&str>> {
    map(alt((
        tuple((tag(" "), tag(" "), tag(" "), space0)),
        tuple((tag("["), alpha0, tag("]"), space0))
    )), |(_, boxa, _, _): (&str, &str, &str, &str)| if boxa == " " { None } else { Some(boxa) })(raw)
}

fn gen_crates<'a>(raw: &'a str) -> Vec<Crate<'a>> {
    let mut rcrates = raw
        .split('\n')
        .collect_vec();

    let crate_ids = rcrates.pop();

    rcrates
        .into_iter()
        .zip(crate_idents.into_iter())
        .map(|(crates, id)| parse_crate(id, crates))
        .collect()
}

fn lex_instruction(raw: &str) -> IResult<&str, Instruction> {
    map(tuple((
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
        digit0
    )), parse_instruction)(raw)
}

fn parse_instruction((_,_,count,_,_,_,from,_,_,_,to): (&str,&str,&str,&str,&str,&str,&str,&str,&str,&str,&str)) -> Instruction {
    Instruction {
        from: from.parse::<usize>().unwrap(),
        to: to.parse::<usize>().unwrap(),
        count: count.parse::<usize>().unwrap()
    }
}

fn gen_instructions(raw: &str) -> Vec<Instruction> {
    raw
        .trim()
        .split('\n')
        .map(|line| line.trim() )
        .map(lex_instruction)
        .map(|result| {
            match result {
                Ok((_, x)) => x,
                Err(_) => panic!("Invalid Instruction")
            }
        })
        .collect()
}

fn process_instruction(i: Instruction, crates: &mut Vec<Crate>) {
    let mut from_crate = crates.iter_mut().find(|x| x.id == i.from ).unwrap();
    let box_count = from_crate.boxes.len().saturating_sub(i.count);
    let move_boxes = from_crate.boxes.split_off(box_count);
    let mut to_crate   = crates.iter_mut().find(|x| x.id == i.to ).unwrap();
    move_boxes.iter().for_each(|mbox| to_crate.boxes.push(mbox));
}

pub fn solve() -> String {
    let raw = fs::read_to_string("data/example/2022/day5.txt").unwrap();
    let (raw_crates, raw_instructions) = raw.split_once("\n\n").unwrap();
    let mut crates = gen_crates(raw_crates);
    dbg!(&crates);
    let instructions = gen_instructions(raw_instructions);
    instructions.into_iter().for_each(|instruction| process_instruction(instruction, &mut crates) );


    String::from("UNSOLVED")
}
