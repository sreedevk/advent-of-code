
pub fn transpose<T>(x: Vec<Vec<T>>) -> Vec<Vec<T>>
where
    T: Clone {
        assert!(!x.is_empty());
        (0..x[0].len())
            .map(|i| x.iter().map(|inner| inner[i].clone()).collect::<Vec<T>>())
            .collect()
}

pub fn rotate_cw<T>(x: Vec<Vec<T>>) -> Vec<Vec<T>>
where
    T: Clone {
        assert!(!x.is_empty());
        transpose(x)
            .into_iter()
            .map(|x| x.into_iter().rev().collect::<Vec<T>>() )
            .collect()
}

pub fn rotate_ccw<T>(x: Vec<Vec<T>>) -> Vec<Vec<T>>
where
    T: Clone {
        assert!(!x.is_empty());
            transpose(
                x.into_iter()
                .map(|x| x.into_iter().rev().collect::<Vec<T>>() )
                .collect()
            )
}
