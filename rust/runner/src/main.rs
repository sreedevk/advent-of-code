use aoc_utils::Aoc;
use std::env;
use std::process::exit;

/* cargo run 2021 1*/
#[tokio::main]
async fn main() {
    let args: Vec<String> = env::args().collect();
    print_intro(&args[2], &args[3]);

    match args[1].as_str() {
        "fetch" => {
            Aoc::fetch(&args[2], &args[3]).await;
            exit(0);
        }
        "scaffold" => {
            Aoc::scaffold(&args[2], &args[3]).await;
            exit(0)
        }
        "solve" => {
            let solution = find_solution(&args[2], &args[3]);
            if solution.is_none() {
                exit(0)
            }
            run_solution(solution.unwrap());
        }
        "submit" => {
            let solution = find_solution(&args[2], &args[3]);
            if solution.is_none() {
                exit(0)
            }
            submit_solution(solution.unwrap(), args).await;
        }
        _ => println!("Invalid Action"),
    };
}

fn print_intro(year: &str, day: &str) {
    println!("------------------------------------------------");
    println!("🎄 Advent of code {} 🎄 Day {}", year, day);
    println!("------------------------------------------------\n");
}

async fn submit_solution(func: fn() -> [String; 2], args: Vec<String>) {
    let [solution1, solution2] = func();
    match args[4].as_str() {
        "1" => Aoc::submit(args[2].as_str(), args[3].as_str(), "1", solution1.as_str()).await,
        "2" => Aoc::submit(args[2].as_str(), args[3].as_str(), "2", solution2.as_str()).await,
        _ => panic!("Invalid Part Identifier"),
    }
}

fn find_solution(year: &str, day: &str) -> Option<fn() -> [String; 2]> {
    match year {
        "2022" => match day {
            "1" => Some(solutions_2022::day1::Day1::solve),
            "2" => Some(solutions_2022::day2::Day2::solve),
            "3" => Some(solutions_2022::day3::Day3::solve),
            "4" => Some(solutions_2022::day4::Day4::solve),
            _ => None,
        },
        "2021" => match day {
            "1" => Some(solutions_2021::day1::Day1::solve),
            "2" => Some(solutions_2021::day2::Day2::solve),
            "3" => Some(solutions_2021::day3::Day3::solve),
            "12" => Some(solutions_2021::day12::Day12::solve),
            "13" => Some(solutions_2021::day13::Day13::solve),
            _ => None,
        },
        "2018" => match day {
            "3" => Some(solutions_2018::day3::Day3::solve),
            _ => None,
        },
        "2015" => match day {
            "1" => Some(solutions_2015::day1::Day1::solve),
            "7" => Some(solutions_2015::day7::Day7::solve),
            _ => None,
        },
        _ => None,
    }
}

fn run_solution(func: fn() -> [String; 2]) {
    let init_time = chrono::Utc::now();
    let solution = func();
    let end_time = chrono::Utc::now();

    print_solution(solution);
    print_benchmarks(end_time - init_time);
}

fn print_solution(solution: [String; 2]) {
    solution
        .into_iter()
        .enumerate()
        .for_each(|(i, soln)| println!("PART {}: {}", i, soln));

    println!("\n------------------------------------------------");
}

fn print_benchmarks(duration: chrono::Duration) {
    if duration.num_seconds() > 0 {
        println!("exec time: {:?} seconds", duration.num_seconds())
    } else if duration.num_milliseconds() > 0 {
        println!("exec time: {:?} ms", duration.num_milliseconds())
    } else if duration.num_microseconds().unwrap() > 10 {
        println!(
            "exec time: {:?} µs",
            duration.num_microseconds().unwrap()
        )
    } else {
        println!("exec time: {:?} ns", duration.num_nanoseconds().unwrap())
    }
}
