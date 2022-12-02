mod part1;
mod part2;

use common::grid;
use std::fs;

pub struct Day13;

pub type Coordinate = (usize, usize);
pub type Grid = Vec<Vec<usize>>;

#[derive(Debug)]
pub struct Fold {
    pub axis: usize,
    pub mag: usize,
}

pub fn print_grid(dgrid: &Grid) {
    dgrid.iter().for_each(|row| {
        println!("{:?}", {
            row.iter()
                .map(|col| if *col == 0 { '.' } else { '#' })
                .collect::<String>()
        })
    });
}

pub fn max_x(coords: &[Coordinate]) -> usize {
    coords
        .iter()
        .max_by(|a, b| a.0.cmp(&b.0)).map(|a| a.0 + 1)
        .unwrap_or(1)
}

pub fn max_y(coords: &[Coordinate]) -> usize {
    coords
        .iter()
        .max_by(|a, b| a.1.cmp(&b.1)).map(|a| a.1 + 1)
        .unwrap_or(1)

}

fn fold_x(cgrid: &Grid, mag: usize) -> Grid {
    let (left, nright) = grid::split_at_x(cgrid, mag);
    let right = grid::flip_x(&nright);

    left.iter()
        .zip(right.iter())
        .map(|(a1, b1)| {
            a1.iter()
                .zip(b1.iter())
                .map(|(a2, b2)| if *a2 == 1 || *b2 == 1 { 1 } else { 0 })
                .collect::<Vec<usize>>()
        })
        .collect::<Vec<Vec<usize>>>()
}

fn fold_y(cgrid: &Grid, mag: usize) -> Grid {
    let (top, nbottom) = grid::split_at_y(cgrid, mag);
    let bottom = grid::flip_y(&nbottom);

    top.iter()
        .zip(bottom.iter())
        .map(|(a1, b1)| {
            a1.iter()
                .zip(b1.iter())
                .map(|(a2, b2)| if *a2 == 1 || *b2 == 1 { 1 } else { 0 })
                .collect::<Vec<usize>>()
        })
        .collect::<Vec<Vec<usize>>>()
}

pub fn fold(cgrid: &Grid, fold: &Fold) -> Grid {
    match fold.axis {
        0 => fold_x(cgrid, fold.mag),
        1 => fold_y(cgrid, fold.mag),
        _ => panic!("invalid axis"),
    }
}

impl Day13 {
    pub fn solve() -> [String; 2] {
        let coords = Self::read_coordinates();
        let folds = Self::read_folds();
        [part1::solve(&coords, &folds), part2::solve(&coords, &folds)]
    }

    fn read_coordinates() -> Vec<Coordinate> {
        let data = fs::read_to_string("data/main/2021/day13.txt").unwrap();
        let (raw_coords, _) = data.trim().split_once("\n\n").unwrap();
        raw_coords
            .split('\n')
            .map(|coord| {
                let (x_str, y_str) = coord.trim().split_once(',').unwrap();
                (
                    x_str.parse::<usize>().unwrap(),
                    y_str.parse::<usize>().unwrap(),
                )
            })
            .collect()
    }

    fn read_folds() -> Vec<Fold> {
        let parse_fold = |raw: &Vec<&str>| -> Fold {
            let (axis_str, mag_str) = (raw[0], raw[1]);
            let axis = match axis_str {
                "x" => 0,
                "y" => 1,
                _ => 3, /* case does not exist for this aoc problem */
            };
            Fold {
                axis,
                mag: mag_str.parse::<usize>().unwrap(),
            }
        };

        let data = fs::read_to_string("data/main/2021/day13.txt").unwrap();
        let (_, raw_folds) = data.trim().split_once("\n\n").unwrap();
        raw_folds
            .split('\n')
            .map(|fold| fold.split(' ').last().unwrap())
            .map(|fold| fold.split('=').collect::<Vec<&str>>())
            .map(|fold| parse_fold(&fold))
            .collect()
    }
}
