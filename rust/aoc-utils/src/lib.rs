use std::{env, fs};
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

        fs::create_dir_all(format!("data/main/{}", year));
        fs::write(format!("data/main/{}/{}.txt", year, day), input);
        fs::write(format!("data/example/{}/{}.txt", year, day), input);
    }
}

