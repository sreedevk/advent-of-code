mod part1;
mod part2;
use std::fs;

pub struct Day15;

#[derive(Clone, Debug)]
pub struct Cell(usize, usize);

#[derive(Clone, Debug)]
pub struct Edge(Cell, Cell, usize);

#[derive(Clone, Debug)]
pub struct Graph {
    pub vertices: Vec<Cell>,
    pub edges: Vec<Edge>,
}

pub fn neighbors(cell: &Cell, map: &Vec<Vec<usize>>) -> Vec<Cell> {
    let mut nbrs: Vec<Cell> = Vec::with_capacity(9);
    if !(cell.1 >= map.len() - 1) {
        nbrs.push(Cell(cell.0, cell.1 + 1));
    }
    if !(cell.1 <= 0) {
        nbrs.push(Cell(cell.0, cell.1 - 1));
    }
    if !(cell.0 <= 0) {
        nbrs.push(Cell(cell.0 - 1, cell.1));
    }
    if !(cell.0 >= map.first().unwrap().len() - 1) {
        nbrs.push(Cell(cell.0 + 1, cell.1));
    }

    nbrs
}

pub fn build_graph() -> Graph {
    let raw_data = fs::read_to_string("data/example/2021/day15.txt").expect("file_not_found");
    let map: Vec<Vec<usize>> = raw_data
        .trim()
        .split("\n")
        .map(|line| {
            line.chars()
                .map(|x| usize::from_str_radix(&x.to_string(), 10).unwrap_or_default())
                .collect()
        })
        .collect();

    let mut graph = Graph {
        vertices: vec![],
        edges: vec![],
    };

    for (y, row) in map.iter().enumerate() {
        for (x, _col) in row.iter().enumerate() {
            let cell = Cell(x, y);
            graph.vertices.push(cell.clone());
            let neighboring_cells = neighbors(&cell, &map);
            for neighboring_cell in neighboring_cells {
                let edge_val = map[neighboring_cell.1][neighboring_cell.1];
                graph.edges.push(Edge(cell.clone(), neighboring_cell, edge_val));
            }
        }
    }

    graph
}

impl Day15 {
    pub fn solve() -> [String; 2] {
        build_graph();
        [part1::solve(), part2::solve()]
    }
}
