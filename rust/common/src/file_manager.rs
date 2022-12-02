use std::fs;

pub fn readlines(path: &str) -> Vec<String> {
    read(path)
        .split('\n')
        .filter(|x| !x.is_empty())
        .map(String::from)
        .collect::<Vec<String>>()
}

pub fn read(path: &str) -> String {
    fs::read_to_string(path).expect("Unable to load data into memory")
}
