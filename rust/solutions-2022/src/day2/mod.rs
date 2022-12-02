mod part1;
mod part2;
use std::thread;

pub struct Day2;

impl Day2 {
    pub fn solve() -> [String; 2] {
        let p1 = thread::spawn(part1::solve);
        let p2 = thread::spawn(part2::solve);
        [p1.join().unwrap(), p2.join().unwrap()]
    }
}

