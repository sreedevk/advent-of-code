use crate::template::Solution;
use anyhow::Result;

const DATA: &str = include_str!("../../data/day02.txt");
// const EXAMPLE: &str = include_str!("../../data/day02_example.txt");

pub struct Day02;

#[derive(Debug, Clone, Hash, PartialEq, Eq)]
enum Cube {
    Red(u32),
    Blue(u32),
    Green(u32),
    Invalid,
}

#[derive(Debug, Clone)]
struct Game {
    id: u32,
    pub sets: Vec<Vec<Cube>>,
}

#[derive(Debug, Clone)]
struct Config {
    red: u32,
    green: u32,
    blue: u32,
}

impl Game {
    pub fn is_valid(&self, config: Config) -> bool {
        self.sets
            .clone()
            .into_iter()
            .filter(|cubes| {
                cubes.iter().any(|cube| match cube {
                    Cube::Green(count) => count.gt(&config.green),
                    Cube::Red(count) => count.gt(&config.red),
                    Cube::Blue(count) => count.gt(&config.blue),
                    _ => false,
                })
            })
            .count()
            .eq(&0)
    }

    pub fn min_cubes(&self) -> u32 {
        Ok::<(u32, u32, u32), anyhow::Error>(self.sets.iter().fold(
            (0, 0, 0),
            |(max_red, max_blue, max_green), cubes| {
                cubes.iter().fold(
                    (max_red, max_blue, max_green),
                    |(red, blue, green), cube| match cube {
                        Cube::Red(x) => (red.max(*x), blue, green),
                        Cube::Blue(x) => (red, blue.max(*x), green),
                        Cube::Green(x) => (red, blue, green.max(*x)),
                        _ => (red, blue, green),
                    },
                )
            },
        ))
        .map(|(max_red, max_blue, max_green)| max_red * max_blue * max_green)
        .unwrap_or(0)
    }
}

mod parser {
    use super::{Cube, Game};
    use nom::{
        branch::alt,
        bytes::complete::tag,
        character::complete::{digit1, line_ending, space1},
        combinator::{eof, map_res},
        multi::{many1, separated_list1},
        sequence::{terminated, tuple},
        Err as NomErr, IResult,
    };
    pub struct Parser;

    impl Parser {
        pub fn games(input: &str) -> IResult<&str, Vec<Game>> {
            map_res(
                many1(tuple((Self::game_id, many1(Self::game_set)))),
                |games: Vec<(u32, Vec<Vec<Cube>>)>| {
                    Ok::<Vec<Game>, NomErr<&str>>(
                        games
                            .into_iter()
                            .map(|(id, sets)| Game { id, sets })
                            .collect(),
                    )
                },
            )(input)
        }

        fn game_id(input: &str) -> IResult<&str, u32> {
            map_res(
                tuple((tag("Game "), map_res(digit1, str::parse::<u32>), tag(":"))),
                |(_, id, _)| Ok::<u32, NomErr<&str>>(id),
            )(input)
        }

        fn game_set(input: &str) -> IResult<&str, Vec<Cube>> {
            map_res(
                terminated(
                    separated_list1(
                        tag(","),
                        tuple((
                            space1,
                            map_res(digit1, str::parse::<u32>),
                            space1,
                            alt((tag("blue"), tag("red"), tag("green"))),
                        )),
                    ),
                    alt((tag(";"), eof, line_ending)),
                ),
                |combinations: Vec<(&str, u32, &str, &str)>| {
                    Ok::<Vec<Cube>, NomErr<&str>>(
                        combinations
                            .into_iter()
                            .map(|(_, count, _, color)| match color {
                                "red" => Cube::Red(count),
                                "green" => Cube::Green(count),
                                "blue" => Cube::Blue(count),
                                _ => Cube::Invalid,
                            })
                            .collect::<Vec<Cube>>(),
                    )
                },
            )(input)
        }
    }
}

use parser::Parser;

impl Solution for Day02 {
    fn solve_part1(&self) -> Result<String> {
        Ok(Parser::games(DATA)
            .map(|(_, parsed)| parsed)?
            .into_iter()
            .filter(|game| {
                game.is_valid(Config {
                    red: 12,
                    green: 13,
                    blue: 14,
                })
            })
            .map(|game| game.id)
            .sum::<u32>()
            .to_string())
    }

    fn solve_part2(&self) -> Result<String> {
        Ok(Parser::games(DATA)
            .map(|(_, parsed)| parsed)?
            .into_iter()
            .map(|game| game.min_cubes())
            .sum::<u32>()
            .to_string())
    }
}
