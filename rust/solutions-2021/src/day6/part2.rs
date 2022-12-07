use super::FishCounter;
use itertools::Itertools;
use std::fs;

fn step_gen(state: FishCounter, max_gens: usize, current_gen: usize) -> FishCounter {
    let finstate = state
        .into_iter()
        .fold(FishCounter::new(), |mut new_state, (age, count)| {
            if age == 0 {
                new_state
                    .entry(6)
                    .and_modify(|ct| *ct += count)
                    .or_insert(count);
                new_state
                    .entry(8)
                    .and_modify(|ct| *ct += count)
                    .or_insert(count);
                new_state
            } else {
                new_state
                    .entry(age - 1)
                    .and_modify(|ct| *ct += count)
                    .or_insert(count);
                new_state
            }
        });

    if current_gen >= max_gens {
        finstate
    } else {
        step_gen(finstate, max_gens, current_gen + 1)
    }
}

fn tally(input: Vec<usize>) -> FishCounter {
    input
        .into_iter()
        .fold(FishCounter::new(), |mut ctr: FishCounter, num| {
            ctr.entry(num)
                .and_modify(|counter| *counter += 1)
                .or_insert(1);
            ctr
        })
}

fn parse_input(input: &str) -> Vec<usize> {
    input
        .trim()
        .split(',')
        .map(|num| num.parse::<usize>().unwrap())
        .collect_vec()
}

pub fn solve() -> String {
    let input = fs::read_to_string("data/main/2021/day6.txt").unwrap();
    let final_gen = step_gen(tally(parse_input(input.as_str())), 256, 1)
        .values()
        .sum::<usize>();

    format!("{}", final_gen)
}

