use std::{env, fs};
use std::fs::OpenOptions;
use std::io::prelude::*;

pub struct Aoc;

impl Aoc {
    pub async fn fetch(year: &str, day: &str) {
        let aoc_token = env::var("AOC_SESSION_TOKEN").unwrap();
        let client = reqwest::Client::builder().build().unwrap();

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
        let raw_template = fs::read_to_string("templates/solution_template.rs")
            .expect("unable to find template")
            .replace("{dayident}", day);

        let mut solutions_lib = OpenOptions::new()
            .append(true)
            .open(format!("solutions-{}/src/lib.rs", year))
            .unwrap();
        
        let solutions_mod_incl = format!("pub mod day{};", day);

        /* create directories */
        fs::create_dir_all(format!("data/main/{}", year)).unwrap();
        fs::create_dir_all(format!("solutions-{}/src/day{}/", year, day)).unwrap();

        /* write input data*/
        fs::write(format!("data/main/{}/{}.txt", year, day), &input).unwrap();
        fs::write(format!("data/example/{}/{}.txt", year, day), &input).unwrap();

        /* write files for solution */
        fs::write(format!("solutions-{}/src/day{}/mod.rs", year, day), raw_template).unwrap();
        solutions_lib.write_all(solutions_mod_incl.as_bytes()).unwrap();
    }
}

