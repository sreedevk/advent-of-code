use common::file_manager;

pub struct Day1;

impl Day1 {
    pub fn solve() -> [String; 2] {
        [
            Self::solve1(),
            Self::solve2()
        ]
    }

    fn solve1() -> String {
        file_manager::read("data/main/2015/day1.txt")
            .trim()
            .chars()
            .fold(0, |count, current| {
                match current {
                    '(' => count + 1,
                    ')' => count - 1,
                    _ => panic!("char not found!")
                }
            })
            .to_string()
    }

    fn solve2() -> String {
        let mut solution = 0;

        file_manager::read("data/main/2015/day1.txt")
            .trim()
            .chars()
            .enumerate()
            .fold(0, |acc, (index, current)| {
                if acc < 0 && solution == 0 { solution = index } 
                match current {
                    '(' => acc + 1,
                    ')' => acc - 1,
                    _ => panic!("char not found!")
                }
            });
        solution.to_string()
    }
}
