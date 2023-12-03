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
pub fn solve_part1(input: &str) -> u32 {
    Parser::games(input)
        .map(|(_, parsed)| parsed)
        .unwrap_or_default()
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
}

pub fn solve_part2(input: &str) -> u32 {
    Parser::games(input)
        .map(|(_, parsed)| parsed)
        .unwrap_or_default()
        .into_iter()
        .map(|game| game.min_cubes())
        .sum::<u32>()
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_part_a() {
        let test_data = vec![
            "Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green",
            "Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue",
            "Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red",
            "Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red",
            "Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green",
        ]
        .join("\n");
        let solution = solve_part1(&test_data);
        assert_eq!(solution, 8)
    }

    #[test]
    fn test_part_b() {
        let test_data = vec![
            "Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green",
            "Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue",
            "Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red",
            "Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red",
            "Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green",
        ]
        .join("\n");
        let solution = solve_part2(&test_data);
        assert_eq!(solution, 2286)
    }
}
