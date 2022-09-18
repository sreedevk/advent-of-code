pub struct Day3;
use common::*;
use uint::construct_uint;

construct_uint! {
	pub struct U1024(16);
}

impl Day3 {
    pub fn solve() -> [String; 2] {
        [
            Day3::solve1(),
            Day3::solve2(),
        ]
    }

    fn processed_data() -> Vec<(usize, usize)> {
        let input_data: Vec<Vec<char>> = file_manager::readlines("data/main/2021/day3.txt")
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

    fn solve1() -> String {
        let gamma_rate_bin_str = Day3::processed_data()
            .iter()
            .map(|(one_count, zero_count)| if one_count > zero_count { 1u8 } else { 0u8 })
            .fold(String::new(), |iterator, next| String::from(format!("{}{:?}", iterator, next)));

        let epsilon_rate_bin_str = Day3::processed_data()
            .iter()
            .map(|(one_count, zero_count)| if zero_count > one_count { 1u8 } else { 0u8 })
            .fold(String::new(), |iterator, next| String::from(format!("{}{:?}", iterator, next)));

        let gamma_rate   = u32::from_str_radix(gamma_rate_bin_str.as_str(), 2).unwrap();
        let epsilon_rate = u32::from_str_radix(epsilon_rate_bin_str.as_str(), 2).unwrap();

        return String::from(format!("{}", gamma_rate * epsilon_rate));
    }

    fn solve2() -> String {
        let solution = "UNSOLVED";
        return String::from(format!("{}", solution));
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
