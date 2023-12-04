#![allow(unused)]
use crate::template::Solution;
use anyhow::Result;

pub struct Day04;

const DATA: &str = include_str!("../../data/day04.txt");
const EXAMPLE: &str = include_str!("../../data/day04_example.txt");

#[derive(Debug)]
struct Card {
    id: u32,
    winning_numbers: Vec<u32>,
    own_numbers: Vec<u32>,
    points: u32,
}

mod parser {
    // Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
    use super::Card;
    use nom::{
        branch::alt,
        bytes::complete::{is_not, tag, take_while1},
        character::complete::{anychar, digit1, newline, one_of, space0},
        combinator::{eof, map_res},
        multi::{many1, many_till},
        sequence::{terminated, tuple},
        Err, IResult,
    };

    pub struct Parser;

    impl Parser {
        pub fn parse<'a>(input: &'a str) -> IResult<&'a str, Vec<Card>> {
            let card_number_parser = |inp: &'a str| -> IResult<&'a str, u32> {
                map_res(
                    tuple((
                        tag("Card "),
                        map_res(digit1, |s: &'a str| -> Result<u32, Err<&'a str>> {
                            Ok(s.parse::<u32>().unwrap())
                        }),
                        tag(": "),
                    )),
                    |(_, card_id, _)| Ok::<u32, Err<&'a str>>(card_id),
                )(inp)
            };

            let winning_numbers_parser = |inp: &'a str| -> IResult<&str, Vec<u32>> {
                terminated(
                    many1(map_res(terminated(digit1, space0), |n: &str| {
                        Ok::<u32, Err<&str>>(n.parse::<u32>().unwrap())
                    })),
                    tag("| "),
                )(inp)
            };

            let own_numbers_parser = |inp: &'a str| -> IResult<&str, Vec<u32>> {
                terminated(
                    many1(map_res(terminated(digit1, space0), |n: &str| {
                        Ok::<u32, Err<&str>>(n.parse::<u32>().unwrap())
                    })),
                    alt((tag("\n"), eof)),
                )(inp)
            };

            let card_parser = |inp: &'a str| -> IResult<&'a str, Card> {
                map_res(
                    tuple((
                        card_number_parser,
                        winning_numbers_parser,
                        own_numbers_parser,
                    )),
                    |(card_id, winning, own)| {
                        Ok::<Card, Err<&'a str>>(Card {
                            id: card_id,
                            winning_numbers: winning,
                            own_numbers: own,
                            points: 0,
                        })
                    },
                )(inp)
            };

            let mut card_list_parser = many1(card_parser);
            card_list_parser(input)
        }
    }
}

use parser::Parser;

impl Solution for Day04 {
    fn solve_part1(&self) -> Result<String> {
        dbg!(Parser::parse(EXAMPLE));
        Ok("".to_string())
    }

    fn solve_part2(&self) -> Result<String> {
        Ok("".to_string())
    }
}
