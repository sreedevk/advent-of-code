#![allow(unused)]
use crate::template::Solution;
use anyhow::Result;
use tap::Tap;

pub struct Day04;

const DATA: &str = include_str!("../../data/day04.txt");
const EXAMPLE: &str = include_str!("../../data/day04_example.txt");

#[derive(Debug)]
struct Card {
    id: u32,
    winning_numbers: Vec<u32>,
    own_numbers: Vec<u32>,
}

impl Card {
    fn points(&self) -> Result<u32> {
        Ok(self
            .winning_numbers
            .iter()
            .filter(|winnum| self.own_numbers.iter().any(|ownnum| ownnum.eq(winnum)))
            .count())
        .map(|cnt| { if cnt.eq(&0) { 0 } else { u32::pow(2, (cnt as u32) - 1) } })
    }
}

mod parser {
    // Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
    use super::Card;
    use nom::{
        branch::alt,
        bytes::complete::{is_not, tag, take_while1},
        character::complete::{anychar, digit1, newline, one_of, space0, space1},
        combinator::{eof, map_res},
        multi::{many1, many_till},
        sequence::{terminated, tuple},
        Err, IResult,
    };

    pub struct Parser;

    impl Parser {
        fn card_number_parser(inp: &str) -> IResult<&str, u32> {
            map_res(
                tuple((
                    tag("Card"),
                    space1,
                    map_res(digit1, |s: &str| -> Result<u32, Err<&str>> {
                        Ok(s.parse::<u32>().unwrap())
                    }),
                    tag(": "),
                )),
                |(_, _, card_id, _)| Ok::<u32, Err<&str>>(card_id),
            )(inp)
        }

        fn own_numbers_parser(inp: &str) -> IResult<&str, Vec<u32>> {
            terminated(
                many1(map_res(
                    tuple((space0, terminated(digit1, space0))),
                    |(_, n): (&str, &str)| Ok::<u32, Err<&str>>(n.parse::<u32>().unwrap()),
                )),
                alt((tag("\n"), eof)),
            )(inp)
        }

        fn winning_numbers_parser(inp: &str) -> IResult<&str, Vec<u32>> {
            terminated(
                many1(map_res(
                    tuple((space0, terminated(digit1, space0))),
                    |(_, n): (&str, &str)| Ok::<u32, Err<&str>>(n.parse::<u32>().unwrap()),
                )),
                tag("| "),
            )(inp)
        }

        fn card_parser(inp: &str) -> IResult<&str, Card> {
            map_res(
                tuple((
                    Self::card_number_parser,
                    Self::winning_numbers_parser,
                    Self::own_numbers_parser,
                )),
                |(card_id, winning, own)| {
                    Ok::<Card, Err<&str>>(Card {
                        id: card_id,
                        winning_numbers: winning,
                        own_numbers: own,
                    })
                },
            )(inp)
        }

        fn card_list_parser(inp: &str) -> IResult<&str, Vec<Card>> {
            many1(Self::card_parser)(inp)
        }

        pub fn parse<'a>(input: &'a str) -> IResult<&'a str, Vec<Card>> {
            Self::card_list_parser(input)
        }
    }
}

use parser::Parser;

impl Solution for Day04 {
    fn solve_part1(&self) -> Result<String> {
        Ok(Parser::parse(DATA)
            .map(|(_, res)| res)?
            .iter()
            .map(|card| Card::points(card).unwrap_or_default())
            .sum::<u32>()
            .to_string())
    }

    fn solve_part2(&self) -> Result<String> {
        Ok("".to_string())
    }
}
