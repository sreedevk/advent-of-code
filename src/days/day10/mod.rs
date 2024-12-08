use crate::template::Solution;
use anyhow::Result;

#[derive(Debug, Clone)]
enum Instruction {
    Noop,
    Addx(isize),
}

#[derive(Debug, Clone)]
struct Program {
    pub instructions: Vec<Instruction>,
}

#[derive(Debug, Clone)]
struct Machine {
    pub accumulator: isize,
    pub queue: Vec<(Instruction, u8)>,
    pub program: Program,
}

impl Machine {
    pub fn new(program: Program) -> Self {
        Self {
            accumulator: 1,
            queue: vec![],
            program,
        }
    }

    pub fn run(&mut self) -> Result<Vec<(usize, isize)>> {
        let mut instructions: Vec<Instruction> = self
            .program
            .instructions
            .clone()
            .into_iter()
            .rev()
            .collect();
        let mut cycles: usize = 0;
        let mut results: Vec<(usize, isize)> = vec![];
        'machine: loop {
            if let Some(current_instruction) = instructions.pop() {
                match current_instruction {
                    Instruction::Noop => {
                        cycles += 1;
                        results.push((cycles, self.accumulator));
                    }
                    Instruction::Addx(num) => {
                        cycles += 2;
                        results.push((cycles - 1, self.accumulator));
                        self.accumulator += num;
                        results.push((cycles, self.accumulator));
                    }
                }
            } else {
                break 'machine;
            }
        }

        Ok(results)
    }
}

mod parser {
    use super::{Instruction, Program};
    use nom::{
        branch::alt,
        bytes::complete::tag,
        character::complete::{digit1, line_ending, space1},
        combinator::{eof, map_res},
        multi::many1,
        sequence::{preceded, tuple},
        IResult,
    };

    pub fn parse<'a>(input: &'a str) -> IResult<&str, Program> {
        let noop_parser = |inp: &'a str| -> IResult<&str, Instruction> {
            map_res(tuple((tag("noop"), alt((line_ending, eof)))), |_| {
                Ok::<Instruction, nom::Err<&str>>(Instruction::Noop)
            })(inp)
        };

        let number_parser = |inp: &'a str| -> IResult<&str, isize> {
            alt((
                map_res(preceded(tag("-"), digit1), |num: &str| {
                    Ok::<isize, nom::Err<&str>>(0 - num.parse::<isize>().unwrap_or_default())
                }),
                map_res(digit1, |num: &str| num.parse::<isize>()),
            ))(inp)
        };

        let addx_parser = |inp: &'a str| -> IResult<&str, Instruction> {
            map_res(
                tuple((tag("addx"), space1, number_parser, alt((line_ending, eof)))),
                |(_, _, num, _)| Ok::<Instruction, nom::Err<&str>>(Instruction::Addx(num)),
            )(inp)
        };

        let program_paser = |inp: &'a str| -> IResult<&str, Program> {
            map_res(many1(alt((addx_parser, noop_parser))), |result| {
                let instructions = result.iter().map(|i| i.clone()).collect();
                Ok::<Program, nom::Err<&str>>(Program { instructions })
            })(inp)
        };

        program_paser(input)
    }
}

pub struct Day10;

const DATA: &str = include_str!("../../../data/day10.txt");

impl Solution for Day10 {
    fn solve_part1(&self) -> Result<String> {
        let (_, program) = parser::parse(DATA)?;
        let mut machine = Machine::new(program);
        let results = machine.run()?;
        let signal_strengths = results
            .into_iter()
            .map(|(cyc, acc)| (cyc as isize) * acc)
            .collect::<Vec<isize>>();

        dbg!(signal_strengths[19]);
        Ok("".to_string())
    }

    fn solve_part2(&self) -> Result<String> {
        Ok("".to_string())
    }
}
