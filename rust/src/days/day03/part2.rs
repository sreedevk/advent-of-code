use itertools::Itertools;

fn three_way(a: &[usize], b: &[usize], c: &[usize]) -> usize {
    *a.iter()
        .find(|x| b.contains(x) && c.contains(x))
        .unwrap()
}

pub fn solve(input: &str) -> String {
    let priorities_sum = input
        .trim()
        .split('\n')
        .map(|sack| sack.trim().chars())
        .map(|sack| sack.map(super::to_priority))
        .map(|sack| sack.collect_vec())
        .chunks(3)
        .into_iter()
        .map(|chunk| chunk.collect_vec())
        .map(|chunk| three_way(&chunk[0], &chunk[1], &chunk[2]))
        .sum::<usize>();

    format!("{}", priorities_sum)
}
