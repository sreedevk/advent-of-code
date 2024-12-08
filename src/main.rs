mod days;
mod template;

use std::env::args;
use anyhow::Result;

fn main() -> Result<()> {
    let day = args().nth(1).expect("[ERR] Solution Day Not Specified!").parse::<u32>()?;
    let solver = days::fetch(day);

    println!("Solution for Day {}", day);
    println!("Part 1: {}", solver.solve_part1()?);
    println!("Part 2: {}", solver.solve_part2()?);
    Ok(())
}
