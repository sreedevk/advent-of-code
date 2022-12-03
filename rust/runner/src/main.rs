use aoc_utils::Aoc;
use std::env;
use std::process::exit;

/* cargo run 2021 1*/
#[tokio::main]
async fn main() {
    let args: Vec<String> = env::args().collect();
    println!("Advent of code {}, Day {}", args[1], args[2]);

    let solution: Option<fn() -> [String; 2]> = match args[1].as_str() {
        "2022" => match args[2].as_str() {
            "1" => Some(solutions_2022::day1::Day1::solve),
            "2" => Some(solutions_2022::day2::Day2::solve),
            "3" => Some(solutions_2022::day3::Day3::solve),
            _ => None,
        },
        "2021" => match args[2].as_str() {
            "1" => Some(solutions_2021::day1::Day1::solve),
            "2" => Some(solutions_2021::day2::Day2::solve),
            "3" => Some(solutions_2021::day3::Day3::solve),
            "12" => Some(solutions_2021::day12::Day12::solve),
            "13" => Some(solutions_2021::day13::Day13::solve),
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
        "scaffold" => {
            Aoc::scaffold(&args[2], &args[3]).await;
            exit(0)
        }
        _ => None,
    };

    match solution {
        Some(soln) => {
            if args[1] == "submit" {
                let [solution1, solution2] = soln();
                match args[4].as_str() {
                    "1" => {
                        Aoc::submit(args[2].as_str(), args[3].as_str(), "1", solution1.as_str())
                            .await
                    }
                    "2" => {
                        Aoc::submit(args[2].as_str(), args[3].as_str(), "2", solution2.as_str())
                            .await
                    },
                    _ => panic!("Invalid Part Identifier")
                }
            } else {
                solver(soln)
            }
        }
        None => println!("Solution not found!"),
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

    if duration.num_seconds() > 0 {
        println!("Solution took {:?} seconds", duration.num_seconds())
    } else if duration.num_milliseconds() > 0 {
        println!("Solution took {:?} ms", duration.num_milliseconds())
    } else {
        println!(
            "Solution took {:?} µs",
            duration.num_microseconds().unwrap()
        )
    }
}
