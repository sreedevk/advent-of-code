mod part1;
mod part2;

pub struct Day3;

pub fn to_priority(input: char) -> usize {
    if input.is_uppercase() {
        (input as usize) - 38
    } else {
        (input as usize) - 96
    }
}

impl Day3 {
    pub fn solve() -> [String; 2] {
        [
            part1::solve(),
            part2::solve()
        ]
    }
}
