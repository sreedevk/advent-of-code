use std::fs;

pub fn readlines(path: &str) -> Vec<String> {
    return read(path)
        .split("\n")
        .filter(|x| !x.is_empty() )
        .map(|x| String::from(x) )
        .collect::<Vec<String>>();
}

pub fn read(path: &str) -> String {
    return fs::read_to_string(path).expect("Unable to load data into memory");
}
