use itertools::Itertools;

fn intersection((a, b): (&[usize], &[usize])) -> usize {
    *a.iter().find(|x| b.contains(x)).unwrap()
}

pub fn solve(data: &str) -> String {
    let priorities_sum = data
        .trim()
        .split('\n')
        .into_iter()
        .map(|sack| sack.trim().chars())
        .map(|sack| sack.map(super::to_priority).collect_vec())
        .map(|x| intersection(x.split_at(x.len() / 2)))
        .sum::<usize>();

    format!("{}", priorities_sum)
}
