mod part1;
mod part2;

pub struct Day3;

impl Day3 {
    pub fn solve() -> [String; 2] {
        [
            part1::solve(),
            part2::solve()
        ]
    }
}
