use itertools::Itertools;

fn all_unique(chrs: Vec<char>) -> bool {
    chrs == chrs.clone().into_iter().unique().collect_vec()
}

pub fn solve(raw: &str) -> String {
    let init = raw.chars().collect_vec();
    let results = init
        .windows(14)
        .into_iter()
        .enumerate()
        .take_while(|(_, chars)| !all_unique(chars.to_vec()))
        .collect_vec();

    let (result, _) = results.last().unwrap();
    format!("{}", result + 15)
}
