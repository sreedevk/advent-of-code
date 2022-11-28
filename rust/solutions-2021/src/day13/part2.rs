use super::{fold, max_x, max_y, print_grid, Coordinate, Fold};

pub fn solve(coords: &Vec<Coordinate>, folds: &Vec<Fold>) -> String {
    let mut main_grid = vec![vec![0; max_x(coords)]; max_y(coords)];
    coords
        .iter()
        .for_each(|coord| main_grid[coord.1][coord.0] = 1);
    let transformed_grid = folds.iter().fold(main_grid, |cgrid, fld| fold(&cgrid, fld));
    print_grid(&transformed_grid);
    String::from("^")
}
