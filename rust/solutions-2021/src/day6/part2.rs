use super::FishCounter;
use itertools::Itertools;
use std::fs;
use tap::prelude::*;

pub fn solve() -> String {
    fs::read_to_string("data/main/2021/day6.txt")
        .unwrap()
        .pipe(|input| parse_input(input.as_str()))
        .pipe(|input| tally(input))
        .pipe(|input| step_gen(input, 256, 1))
        .pipe(|input| input.values().sum::<usize>())
        .pipe(|solution| format!("{}", solution))
}

fn step_gen(state: FishCounter, max_gens: usize, current_gen: usize) -> FishCounter {
    if current_gen > max_gens {
        return state;
    }
    state
        .into_iter()
        .fold(FishCounter::new(), |new_state, (age, count)| {
            new_state
                .tap_mut(|x| {
                    if age == 0 {
                        x.entry(6).and_modify(|ct| *ct += count).or_insert(count);
                        x.entry(8).and_modify(|ct| *ct += count).or_insert(count);
                    }
                })
                .tap_mut(|x| {
                    if age != 0 {
                        x.entry(age - 1)
                            .and_modify(|ct| *ct += count)
                            .or_insert(count);
                    }
                })
        })
        .pipe(|next_gen| step_gen(next_gen, max_gens, current_gen + 1))
}

fn tally(input: Vec<usize>) -> FishCounter {
    input
        .into_iter()
        .fold(FishCounter::new(), |ctr: FishCounter, num| {
            ctr.tap_mut(|counter| {
                counter
                    .entry(num)
                    .and_modify(|counter| *counter += 1)
                    .or_insert(1);
            })
        })
}

fn parse_input(input: &str) -> Vec<usize> {
    input
        .trim()
        .split(',')
        .map(|num| num.parse::<usize>().unwrap())
        .collect_vec()
}
