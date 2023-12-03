use itertools::Itertools;

fn rangeize(elf: &str) -> (usize, usize) {
    elf.split('-')
        .map(|rawstr| rawstr.parse::<usize>().unwrap())
        .collect_tuple()
        .unwrap()
}

fn overlaps(a: (usize, usize), b: (usize, usize)) -> bool {
    let (amin, amax) = a;
    let (bmin, bmax) = b;

    (bmin..(bmax + 1)).any(|el| (amin..(amax + 1)).contains(&el))
        || (amin..(amax + 1)).any(|el| (bmin..(bmax + 1)).contains(&el))
}

pub fn solve(raw: &str) -> String {
    let solution = raw
        .trim()
        .split('\n')
        .map(|elves| elves.trim().split(',').collect_tuple().unwrap())
        .map(|(elf1, elf2)| (rangeize(elf1), rangeize(elf2)))
        .filter(|(elf1, elf2)| overlaps(elf1.to_owned(), elf2.to_owned()))
        .count();

    format!("{}", solution)
}
