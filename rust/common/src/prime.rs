pub fn sieve_of_eratosthenes(bound: usize) -> Vec<usize> {
    let mut primes: Vec<bool> = (0..=bound)
        .map(|num| num == 2 || num % 2 != 0)
        .collect();

    let mut num = 3;
    while num * num <= bound {        
        let mut j = num * num;
        while j <= bound {
            primes[j] = false;
            j += num;
        }
        num += 2;
    }

    primes
        .into_iter()
        .enumerate()
        .skip(2)
        .filter_map(|(i, p)| if p {Some(i)} else {None})
        .collect::<Vec<usize>>()
}

#[cfg(test)]
mod tests {
    use super::*; 

    #[test]
    fn test_sieve_of_eratosthenes() {
        let gen_primes: Vec<usize> = sieve_of_eratosthenes(100);
        let primes: Vec<usize> = vec![
            2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 
            43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97
        ];

        assert_eq!(primes, gen_primes);
    }
}
