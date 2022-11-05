use std::env;
use solutions_2021;
use solutions_2015;
use solutions_2018;

/* cargo run 2021 1*/
fn main() {
    let args: Vec<String> = env::args().collect();
    let solution: Option<[String; 2]> = match args[1].as_str() {
        "2021" => {
            match args[2].as_str() {
                "1" => Some(solutions_2021::day1::Day1::solve()),
                "2" => Some(solutions_2021::day2::Day2::solve()),
                "3" => Some(solutions_2021::day3::Day3::solve()),
                "12" => Some(solutions_2021::day12::Day12::solve()),
                "16" => Some(solutions_2021::day16::Day16::solve()),
                _ => None
            }
        },
        "2018" => {
            match args[2].as_str() {
                "1" => Some(solutions_2018::day1::Day1::solve()),
                _ => None
            }
        },
        "2015" => {
            match args[2].as_str() {
                "1" => { Some(solutions_2015::day1::Day1::solve()) },
                "7" => { Some(solutions_2015::day7::Day7::solve())}
                _ => None
            }
        }
        _ => None 
    };

    match solution {
        Some(soln) => print_solution(soln),
        None => println!("SOLUTION NOT FOUND")
    }
    
}

fn print_solution(solution: [String; 2]) {
    let formatted_solution = solution
        .into_iter()
        .enumerate()
        .map(|(i, soln)| format!("PART {}: {}", i, soln) )
        .collect::<Vec<String>>();

    println!("{:#?}", formatted_solution);
}
