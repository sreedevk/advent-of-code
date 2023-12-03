use itertools::Itertools;
use regex::Regex;

pub fn solve_part1(input: &str) -> u32 {
    input
        .lines()
        .map(|line| {
            line.trim()
                .chars()
                .filter(|c| c.is_numeric())
                .map(|c| c.to_digit(10).unwrap())
                .collect::<Vec<u32>>()
        })
        .map(|n| (10 * n.first().unwrap()) + n.last().unwrap())
        .sum::<u32>()
}

pub fn solve_part2(input: &str) -> u32 {
    let patterns = [
        "zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine", r"\d",
    ]
    .into_iter()
    .map(|pattern| Regex::new(pattern).unwrap())
    .collect::<Vec<Regex>>();

    let parse_int = |s: &str| -> u32 {
        match s {
            "one" => 1,
            "two" => 2,
            "three" => 3,
            "four" => 4,
            "five" => 5,
            "six" => 6,
            "seven" => 7,
            "eight" => 8,
            "nine" => 9,
            "zero" => 0,
            x => x.parse::<u32>().unwrap(),
        }
    };

    input
        .lines()
        .map(|line| {
            patterns
                .clone()
                .iter()
                .flat_map(|pattern| {
                    pattern
                        .find_iter(line.trim())
                        .map(move |m| (m.start(), m.as_str()))
                        .collect::<Vec<_>>()
                })
                .sorted_by(|(i1, _), (i2, _)| i1.cmp(i2))
                .map(|(_, s)| parse_int(s))
                .collect::<Vec<u32>>()
        })
        .map(|n| (n.first().unwrap() * 10) + n.last().unwrap())
        .sum::<u32>()
}

#[cfg(test)]
mod test {
    use super::*;

    #[test]
    fn test_part_a() {
        let test_data = vec!["1abc2", "pqr3stu8vwx", "a1b2c3d4e5f", "treb7uchet"].join("\n");
        let solution = solve_part1(&test_data);
        assert_eq!(solution, 142)
    }

    #[test]
    fn test_part_b() {
        let test_data = vec![
            "two1nine",
            "eightwothree",
            "abcone2threexyz",
            "xtwone3four",
            "4nineeightseven2",
            "zoneight234",
            "7pqrstsixteen",
        ]
        .join("\n");
        let solution = solve_part2(&test_data);
        assert_eq!(solution, 281)
    }
}
