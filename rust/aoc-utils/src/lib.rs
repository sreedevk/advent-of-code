use std::fs::OpenOptions;
use std::io::prelude::*;
use std::path::Path;
use std::{env, fs};

pub struct Aoc;

impl Aoc {
    pub async fn submit(year: &str, day: &str, part: &str, solution: &str) {
        let params = [("level", part), ("answer", solution)];
        let client = reqwest::Client::new();
        let response = client
            .post(format!(
                "https://adventofcode.com/{}/day/{}/answer",
                year, day
            ))
            .form(&params)
            .send()
            .await
            .unwrap()
            .text()
            .await
            .unwrap();

        println!("{}", response);
    }

    pub async fn scaffold(year: &str, day: &str) {
        if Path::new(format!("solutions-{}/src/day{}/mod.rs", year, day).as_str()).exists() {
            return;
        }

        let raw_template = fs::read_to_string("templates/solution_template.rs")
            .expect("unable to find template")
            .replace("{dayident}", day);

        let mut solutions_lib = OpenOptions::new()
            .append(true)
            .open(format!("solutions-{}/src/lib.rs", year))
            .unwrap();

        let solutions_mod_incl = format!("pub mod day{};", day);

        println!(
            "create dir: {}",
            format!("solutions-{}/src/day{}/", year, day)
        );
        fs::create_dir_all(format!("solutions-{}/src/day{}/", year, day)).unwrap();

        println!(
            "creating: {}",
            format!("solutions-{}/src/day{}/mod.rs", year, day)
        );
        fs::write(
            format!("solutions-{}/src/day{}/mod.rs", year, day),
            raw_template,
        )
        .unwrap();

        println!("modified: {}", solutions_mod_incl);
        solutions_lib
            .write_all(solutions_mod_incl.as_bytes())
            .unwrap();
    }

    pub async fn fetch(year: &str, day: &str) {
        let aoc_token = env::var("AOC_SESSION_TOKEN").unwrap();
        let client = reqwest::Client::builder().build().unwrap();

        println!(
            "fetching: {}",
            format!("https://adventofcode.com/{}/day/{}/input", year, day)
        );

        let input_response = client
            .get(format!(
                "https://adventofcode.com/{}/day/{}/input",
                year, day
            ))
            .header("cookie", format!("session={}", aoc_token).as_str())
            .send()
            .await
            .unwrap();

        let input = input_response.text().await.unwrap();

        /* create directories */
        fs::create_dir_all(format!("data/main/{}", year)).unwrap();

        /* write input data*/
        println!("writing: {}", format!("data/main/{}/day{}.txt", year, day));
        fs::write(format!("data/main/{}/day{}.txt", year, day), &input).unwrap();

        println!("writing: {}", format!("data/example/{}/day{}.txt", year, day));
        fs::write(format!("data/example/{}/day{}.txt", year, day), &input).unwrap();
    }
}
