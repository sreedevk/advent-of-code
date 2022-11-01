pub struct Day3;
use common::{matrix, file_manager};
mod part1;
mod part2;

impl Day3 {
    pub fn solve() -> [String; 2] {
        [
            part1::solve(),
            part2::solve(),
        ]
    }

    pub fn raw_data() -> Vec<String> {
        file_manager::readlines("data/main/2021/day3.txt")
    }

    pub fn processed_data() -> Vec<(usize, usize)> {
        let input_data: Vec<Vec<char>> = Day3::raw_data()
            .into_iter()
            .map(|x| x.chars().collect::<Vec<char>>() )
            .collect();

        matrix::rotate_cw(input_data)
            .into_iter()
            .map(|x| x.into_iter().fold(String::new(), |acc, data| acc + data.to_string().as_str()) )
            .map(|x| x.chars().collect() )
            .map(|x| (Day3::count_ones(&x), Day3::count_zeros(&x)) )
            .collect::<Vec<(usize, usize)>>()
    }

    fn count_zeros(bitstring: &Vec<char>) -> usize {
        bitstring
            .to_owned()
            .into_iter()
            .filter(|y| y.to_owned() == '0' )
            .collect::<Vec<char>>()
            .len()
    }

    fn count_ones(bitstring: &Vec<char>) -> usize {
        bitstring
            .to_owned()
            .into_iter()
            .filter(|y| y.to_owned() == '1' )
            .collect::<Vec<char>>()
            .len()
    }
}
