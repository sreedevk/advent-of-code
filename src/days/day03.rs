#![allow(unused)]

use crate::template::Solution;

pub struct Day03;

const DATA: &str = include_str!("../../data/day03.txt");
const EXAMPLE: &str = include_str!("../../data/day03_example.txt");

#[derive(Debug)]
struct Cell<'a> {
    inner: CellInner<'a>,
    size: usize,
}

#[derive(Debug)]
pub enum CellInner<'a> {
    Value(&'a str),
    Symbol(&'a str),
    Empty,
}

mod parser {
    pub struct Parser;
    use super::{Cell, CellInner};
    use nom::{
        branch::alt,
        bytes::complete::{is_not, tag, take_while1},
        character::complete::{anychar, digit1, newline, one_of},
        combinator::{eof, map_res},
        multi::{many1, many_till},
        sequence::terminated,
        Err, IResult,
    };

    impl Parser {
        pub fn parse(input: &str) -> IResult<&str, Vec<Vec<Cell>>> {
            map_res(
                many1(terminated(many1(Self::parse_cell), alt((eof, tag("\n"))))),
                |c| Ok::<Vec<Vec<Cell>>, Err<&str>>(c.into_iter().collect()),
            )(input)
        }

        pub fn parse_cell(input: &str) -> IResult<&str, Cell> {
            map_res(alt((digit1, is_not(".\n"), tag("."))), |c| {
                let is_number = |c: &str| -> bool { c.chars().all(|c| c.is_numeric()) };
                Ok::<Cell, Err<&str>>(Cell {
                    inner: match c {
                        "." => CellInner::Empty,
                        x if is_number(x) => CellInner::Value(x),
                        x => CellInner::Symbol(x),
                    },
                    size: c.len(),
                })
            })(input)
        }
    }
}

use parser::Parser;

impl Solution for Day03 {
    fn solve_part1(&self) -> anyhow::Result<String> {
        let parsed = Parser::parse(EXAMPLE).map(|(_, res)| res)?;
        dbg!(&parsed);
        Ok("".to_string())
    }

    fn solve_part2(&self) -> anyhow::Result<String> {
        Ok("".to_string())
    }
}
