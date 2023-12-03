mod solutions;

use anyhow::{anyhow, Result};
use solutions::cube_conundrum as day02;
use solutions::scratchcards as day04;
use solutions::trebuchet as day01;
use std::env::args;
use std::fs::File;
use std::io::Read;

fn read_file(path: &str) -> Result<String> {
    let mut file = File::open(path)?;
    let mut contents = String::new();
    file.read_to_string(&mut contents)?;

    Ok(contents)
}

fn main() -> Result<()> {
    let day = args()
        .nth(1)
        .expect("[ERR] Solution Day Not Specified!")
        .parse::<u32>()?;

    match day {
        1 => {
            let input: String = read_file("data/day01.txt")?;
            println!("Part A => {}", day01::solve_part1(&input));
            println!("Part B => {}", day01::solve_part2(&input));

            Ok(())
        }
        2 => {
            let input: String = read_file("data/day02.txt")?;
            println!("Part A => {}", day02::solve_part1(&input));
            println!("Part B => {}", day02::solve_part2(&input));

            Ok(())
        }
        4 => {
            let input: String = read_file("data/day04.txt")?;
            println!("Part A => {}", day04::solve_part1(&input));
            println!("Part B => {}", day04::solve_part2(&input));

            Ok(())
        }
        _ => Err(anyhow!("No Solution Found!")),
    }
}
