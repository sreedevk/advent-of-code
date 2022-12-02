use super::{fold, max_x, max_y, Coordinate, Fold, Grid};

fn count_active(cgrid: &Grid) -> usize {
    cgrid
        .iter()
        .flatten()
        .filter(|cell| **cell == 1)
        .count()
}

pub fn solve(coords: &[Coordinate], folds: &[Fold]) -> String {
    let mut main_grid: Grid = vec![vec![0; max_x(coords)]; max_y(coords)];
    coords
        .iter()
        .for_each(|coord| main_grid[coord.1][coord.0] = 1);

    let transformed_grid = fold(&main_grid, &folds[0]);
    format!("{}", count_active(&transformed_grid))
}
