use std::fs;
use std::collections::HashMap;

#[derive(PartialEq, Eq, Hash)]
#[repr(u8)]
enum Shape {
    Rock = 1,
    Paper = 2,
    Scissors = 3
}

type WinningStrat = HashMap<Shape, Shape>;

pub fn solve() -> String {
    let data = fs::read_to_string("data/main/2022/day2.txt").unwrap();
    let mut win: WinningStrat = WinningStrat::new();
    win.insert(Shape::Rock, Shape::Scissors);
    win.insert(Shape::Scissors, Shape::Paper);
    win.insert(Shape::Paper, Shape::Rock);

    let score = data
        .trim()
        .split("\n")
        .map(|t| t.trim())
        .map(|shapes| shapes.split_once(" ").unwrap())
        .map(|(p0, p1)| {
            let p0n = match p0 {
                "A" => Shape::Rock,
                "B" => Shape::Paper,
                "C" => Shape::Scissors,
                _ => panic!("INVALID SIGN")
            };
            let p1n = match p1 {
                "X" => Shape::Rock,
                "Y" => Shape::Paper,
                "Z" => Shape::Scissors,
                _ => panic!("INVALID SIGN")
            };

            (p0n, p1n)
        })
        .map(|shapes| { score(shapes, &win) })
        .sum::<usize>();

    String::from(format!("{:?}", score))
}

fn score((p1, p2): (Shape, Shape), winstrat: &WinningStrat) -> usize {
    if winstrat.get(&p1).unwrap() == &p2 { return p2 as usize }
    if p1 == p2 { return (p2 as usize) + 3 }

    p2 as usize + 6
}
