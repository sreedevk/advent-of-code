use std::collections::HashMap;
use std::fs;

#[derive(PartialEq, Eq, Hash)]
#[repr(u8)]
enum Shape {
    Rock = 1,
    Paper = 2,
    Scissors = 3,
}

type WinningStrat = HashMap<Shape, Shape>;

fn str_to_shape(istr: &str) -> Shape {
    match istr {
        "A" | "X" => Shape::Rock,
        "B" | "Y" => Shape::Paper,
        "C" | "Z" => Shape::Scissors,
        _ => panic!("INVALID SHAPE"),
    }
}

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
        .map(|(p0, p1)| (str_to_shape(p0), str_to_shape(p1)))
        .map(|shapes| score(shapes, &win))
        .sum::<usize>();

    String::from(format!("{:?}", score))
}

fn score((p1, p2): (Shape, Shape), winstrat: &WinningStrat) -> usize {
    if winstrat.get(&p1).unwrap() == &p2 {
        return p2 as usize;
    }
    if p1 == p2 {
        return (p2 as usize) + 3;
    }

    p2 as usize + 6
}
