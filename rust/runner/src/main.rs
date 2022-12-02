use aoc_utils::Aoc;
use solutions_2015;
use solutions_2018;
use solutions_2021;
use solutions_2022;
use std::env;
use std::process::exit;

/* cargo run 2021 1*/
#[tokio::main]
async fn main() {
    let args: Vec<String> = env::args().collect();
    let solution: Option<fn() -> [String; 2]> = match args[1].as_str() {
        "2022" => match args[2].as_str() {
            "1" => Some(solutions_2022::day1::Day1::solve),
            "2" => Some(solutions_2022::day2::Day2::solve),
            _ => None,
        },
        "2021" => match args[2].as_str() {
            "1" => Some(solutions_2021::day1::Day1::solve),
            "2" => Some(solutions_2021::day2::Day2::solve),
            "3" => Some(solutions_2021::day3::Day3::solve),
            "4" => Some(solutions_2021::day4::Day4::solve),
            "12" => Some(solutions_2021::day12::Day12::solve),
            "13" => Some(solutions_2021::day13::Day13::solve),
            "15" => Some(solutions_2021::day15::Day15::solve),
            "16" => Some(solutions_2021::day16::Day16::solve),
            _ => None,
        },
        "2018" => match args[2].as_str() {
            "3" => Some(solutions_2018::day3::Day3::solve),
            _ => None,
        },
        "2015" => match args[2].as_str() {
            "1" => Some(solutions_2015::day1::Day1::solve),
            "7" => Some(solutions_2015::day7::Day7::solve),
            _ => None,
        },
        "fetch" => {
            Aoc::fetch(&args[2], &args[3]).await;
            exit(0)
        }
        _ => None,
    };

    match solution {
        Some(soln) => solver(soln),
        None => println!("SOLUTION NOT FOUND"),
    }
}

fn solver(func: fn() -> [String; 2]) {
    let init_time = chrono::Utc::now();
    let solution = func();
    let end_time = chrono::Utc::now();
    let duration = end_time - init_time;

    solution
        .into_iter()
        .enumerate()
        .for_each(|(i, soln)| println!("PART {}: {}", i, soln));

    println!(
        "Solved in: {:?} us | {:?} ms",
        duration.num_microseconds().unwrap(),
        duration.num_milliseconds()
    );
}
