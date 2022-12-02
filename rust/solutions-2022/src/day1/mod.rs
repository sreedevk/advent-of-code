pub struct Day1;
use itertools::Itertools;

impl Day1 {
    pub fn solve() -> [String; 2] {
        let p1 = std::thread::spawn(|| Day1::solve1());
        let p2 = std::thread::spawn(|| Day1::solve2());
        let s1 = p1.join();
        let s2 = p2.join();

        [s1.unwrap(), s2.unwrap()]
    }

    fn solve1() -> String {
        let data = std::fs::read_to_string("data/main/2022/day1.txt").unwrap();
        let solution = data
            .trim()
            .split("\n\n")
            .map(|elf| {
                elf.split("\n")
                    .map(|meal| usize::from_str_radix(meal.trim(), 10).unwrap())
                    .sum::<usize>()
            })
            .max();

        String::from(format!("{:?}", solution.unwrap()))
    }

    fn solve2() -> String {
        let data = std::fs::read_to_string("data/main/2022/day1.txt").unwrap();
        let solution = data
            .trim()
            .split("\n\n")
            .map(|elf| {
                elf.split("\n")
                    .map(|meal| usize::from_str_radix(meal.trim(), 10).unwrap())
                    .fold(0, |count, item| count + item)
            })
            .sorted()
            .rev()
            .take(3)
            .sum::<usize>();

        String::from(format!("{:?}", solution))
    }
}
