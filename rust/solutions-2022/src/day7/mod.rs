mod part1;
mod part2;
pub struct Day7;

impl Day7 {
    pub fn solve() -> [String; 2] {
        [part1::solve(), part2::solve()]
    }
}
