fn epsilon_rate() -> u32 {
    let epsilon_rate_bin_str = super::Day3::processed_data()
        .iter()
        .map(|(one_count, zero_count)| if zero_count > one_count { 1u8 } else { 0u8 })
        .fold(String::new(), |iterator, next| String::from(format!("{}{:?}", iterator, next)));

    u32::from_str_radix(epsilon_rate_bin_str.as_str(), 2).unwrap()
}

fn gamma_rate() -> u32 {
    let gamma_rate_bin_str = super::Day3::processed_data()
        .iter()
        .map(|(one_count, zero_count)| if one_count > zero_count { 1u8 } else { 0u8 })
        .fold(String::new(), |iterator, next| String::from(format!("{}{:?}", iterator, next)));
    u32::from_str_radix(gamma_rate_bin_str.as_str(), 2).unwrap()
}

pub fn solve() -> String {
    String::from(format!("{}", gamma_rate() * epsilon_rate()))
}
