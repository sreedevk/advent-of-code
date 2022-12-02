pub fn transpose<T>(x: Vec<Vec<T>>) -> Vec<Vec<T>>
where
    T: Clone,
{
    assert!(!x.is_empty());
    (0..x[0].len())
        .map(|i| x.iter().map(|inner| inner[i].clone()).collect::<Vec<T>>())
        .collect()
}

pub fn rotate_cw<T>(x: Vec<Vec<T>>) -> Vec<Vec<T>>
where
    T: Clone,
{
    assert!(!x.is_empty());
    transpose(x)
        .into_iter()
        .map(|x| x.into_iter().rev().collect::<Vec<T>>())
        .collect()
}

pub fn rotate_ccw<T>(x: Vec<Vec<T>>) -> Vec<Vec<T>>
where
    T: Clone,
{
    assert!(!x.is_empty());
    transpose(
        x.into_iter()
            .map(|x| x.into_iter().rev().collect::<Vec<T>>())
            .collect(),
    )
}

pub fn split_at<T>(input_vec: &Vec<Vec<T>>, axis: usize, mag: usize) -> (Vec<Vec<T>>, Vec<Vec<T>>)
where
    T: Clone,
{
    match axis {
        0 => split_at_y(input_vec, mag),
        1 => split_at_x(input_vec, mag),
        _ => panic!("index out of bounds"),
    }
}

pub fn split_at_x<T>(input_vec: &[Vec<T>], mag: usize) -> (Vec<Vec<T>>, Vec<Vec<T>>)
where
    T: Clone,
{
    let xsize = input_vec[0].len();
    let left: Vec<Vec<_>> = input_vec
        .iter()
        .map(|row| Vec::from(&row[0..mag]))
        .collect();
    let right: Vec<Vec<_>> = input_vec
        .iter()
        .map(|row| Vec::from(&row[(mag + 1)..xsize]))
        .collect::<Vec<Vec<T>>>();

    (left, right)
}

pub fn split_at_y<T>(input_vec: &Vec<Vec<T>>, mag: usize) -> (Vec<Vec<T>>, Vec<Vec<T>>)
where
    T: Clone,
{
    let ysize = input_vec.len();
    let top: Vec<Vec<_>> = Vec::from(&input_vec[0..mag]);
    let bottom: Vec<Vec<_>> = Vec::from(&input_vec[(mag + 1)..ysize]);
    (top, bottom)
}

pub fn flip_x<T>(grid: &[Vec<T>]) -> Vec<Vec<T>>
where
    T: Clone,
{
    let mut output_grid = grid.to_owned();
    output_grid.iter_mut().for_each(|mvec| mvec.reverse());
    output_grid.to_vec()
}

pub fn flip_y<T>(grid: &[Vec<T>]) -> Vec<Vec<T>>
where
    T: Clone,
{
    let mut output_grid = grid.to_owned();
    output_grid.reverse();

    output_grid.to_vec()
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_flip_y() {
        let grid = vec![
            vec![0, 0, 0, 0, 0, 0],
            vec![1, 1, 1, 1, 1, 1],
            vec![2, 2, 2, 2, 2, 2],
            vec![3, 3, 3, 3, 3, 3],
            vec![4, 4, 4, 4, 4, 4],
            vec![5, 5, 5, 5, 5, 5],
        ];
        let flipped = flip_y(&grid);
        assert_eq!(
            flipped,
            vec![
                vec![5, 5, 5, 5, 5, 5],
                vec![4, 4, 4, 4, 4, 4],
                vec![3, 3, 3, 3, 3, 3],
                vec![2, 2, 2, 2, 2, 2],
                vec![1, 1, 1, 1, 1, 1],
                vec![0, 0, 0, 0, 0, 0],
            ]
        );
    }

    #[test]
    fn test_flip_x() {
        let grid = vec![
            vec![0, 1, 2, 3, 4, 5],
            vec![0, 1, 2, 3, 4, 5],
            vec![0, 1, 2, 3, 4, 5],
            vec![0, 1, 2, 3, 4, 5],
            vec![0, 1, 2, 3, 4, 5],
            vec![0, 1, 2, 3, 4, 5],
        ];

        let flipped = flip_x(&grid);
        assert_eq!(
            flipped,
            vec![
                vec![5, 4, 3, 2, 1, 0],
                vec![5, 4, 3, 2, 1, 0],
                vec![5, 4, 3, 2, 1, 0],
                vec![5, 4, 3, 2, 1, 0],
                vec![5, 4, 3, 2, 1, 0],
                vec![5, 4, 3, 2, 1, 0],
            ]
        )
    }

    #[test]
    fn test_split_at_x() {
        let grid = vec![
            vec![0, 1, 2, 3, 4, 5],
            vec![0, 1, 2, 3, 4, 5],
            vec![0, 1, 2, 3, 4, 5],
            vec![0, 1, 2, 3, 4, 5],
            vec![0, 1, 2, 3, 4, 5],
            vec![0, 1, 2, 3, 4, 5],
        ];

        let (left, right) = split_at_x(&grid, 3);
        assert_eq!(
            left,
            vec![
                [0, 1, 2],
                [0, 1, 2],
                [0, 1, 2],
                [0, 1, 2],
                [0, 1, 2],
                [0, 1, 2]
            ]
        );

        assert_eq!(right, vec![[4, 5], [4, 5], [4, 5], [4, 5], [4, 5], [4, 5]]);
    }

    #[test]
    fn test_split_at_y() {
        let grid = vec![
            vec![0, 1, 2, 3, 4, 5],
            vec![0, 1, 2, 3, 4, 5],
            vec![0, 1, 2, 3, 4, 5],
            vec![0, 1, 2, 3, 4, 5],
            vec![0, 1, 2, 3, 4, 5],
            vec![0, 1, 2, 3, 4, 5],
        ];

        let (top, bottom) = split_at_y(&grid, 3);

        assert_eq!(
            top,
            vec![
                vec![0, 1, 2, 3, 4, 5],
                vec![0, 1, 2, 3, 4, 5],
                vec![0, 1, 2, 3, 4, 5],
            ]
        );

        assert_eq!(
            bottom,
            vec![vec![0, 1, 2, 3, 4, 5], vec![0, 1, 2, 3, 4, 5],]
        );
    }
}
