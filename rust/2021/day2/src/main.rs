use std::fs;
mod part1;
mod part2;

fn main() {
    let data = fs::read_to_string("./data.txt").expect("Unable to load Data.");
    println!("PART I: {:#?}", part1::Problem::solve(&data));
    println!("PART II: {:#?}", part2::Problem::solve(&data));
}
