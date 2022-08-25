use std::fs;

fn part1(raw_data: &Vec<i32>) -> usize {
    return raw_data
        .windows(2)
        .map(|input| input[1] > input[0] )
        .filter(|input| *input )
        .collect::<Vec<bool>>()
        .len();
}

fn part2(raw_data: &Vec<i32>) -> usize {
    return raw_data
        .windows(3)
        .map( |input| input.iter().sum() )
        .collect::<Vec<i32>>()
        .windows(2)
        .map( |input| input[1] > input[0] )
        .filter( |input| *input )
        .collect::<Vec<bool>>()
        .len();
}


fn main() {
    let contents = fs::read_to_string("./data.txt").expect("Unable to load data into memory");
    let raw_data = contents
        .split("\n")
        .filter(|&x| !x.is_empty())
        .map(|input| input.parse().unwrap() )
        .collect::<Vec<i32>>();

    println!("PART I: {}", part1(&raw_data));
    println!("PART II: {}", part2(&raw_data));
}
