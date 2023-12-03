use anyhow::Result;

#[allow(unused)]
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
            .filter(|winnum| self.own_numbers.iter().any(|ownnum| ownnum == *winnum))
            .count())
        .map(|cnt| {
            if cnt.eq(&0) {
                0
            } else {
                u32::pow(2, (cnt as u32) - 1)
            }
        })
    }
}

mod parser {
    use super::Card;
    use nom::{
        branch::alt,
        bytes::complete::tag,
        character::complete::{digit1, space0, space1},
        combinator::{eof, map_res},
        multi::many1,
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

        pub fn parse(input: &str) -> IResult<&str, Vec<Card>> {
            Self::card_list_parser(input)
        }
    }
}

use parser::Parser;
pub fn solve_part1(input: &str) -> u32 {
    Parser::parse(input)
        .map(|(_, res)| res)
        .unwrap_or_default()
        .iter()
        .map(|card| Card::points(card).unwrap_or_default())
        .sum::<u32>()
}

pub fn solve_part2(_input: &str) -> i32 {
    0
}
