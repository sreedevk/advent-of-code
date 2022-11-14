# Advent Of Code Solutions

![cxud1s5i396p0nrkz2v4](https://user-images.githubusercontent.com/36154121/144250485-dcf907f5-57a8-4137-8e7a-41e0fe89bce3.png)

### Usage

```bash
  git clone https://github.com/sreedevk/advent-of-code
  cd advent-of-code
```

#### Rust

```bash
  cd rust
  cargo run --release 2021 12 # run solution for 2021 day 12 (part 1 & 2)
  cargo run --release fetch 2021 12 # !will reset the solution file & update the example + data files
```

#### Ruby
```bash
  cd ruby
  rake aoc:auth[cookie]         # Set Cookie for your AOC Account Copied from the browser
  rake aoc:benchmark[year,day]  # Benchmark Solution
  rake aoc:help                 # help
  rake aoc:init[year,day]       # fetch templates
  rake aoc:run[year,day]        # Run Solution
```

#### Elixir

```bash
  mix aoc authenticate <cookie>          # add browser cookie for problem fetching from adventofcode.com
  mix aoc init <year> <day>              # setup files + fetch problem for solving
  mix aoc solve <year> <day>             # run part 1 & part 2 solution for year / day
  mix aoc solve <year> <day> <part>      # run part solution for year / day
  mix aoc benchmark <year> <day>         # run part 1 & part 2 solution for year / day
  mix aoc benchmark <year> <day> <part>  # run part solution for year / day / part
  
  * year format = YY
  * day  format = D
```

#### Clojure

```bash
  cd clojure
  lein run -year- -day- # Running Solution
  lein run 2021 1 benchmark # Benchmarking Solution

## Examples
  lein run 2021 1
  lein run 2021 2 benchmark
```
