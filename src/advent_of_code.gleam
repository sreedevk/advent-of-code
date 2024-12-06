import ceres_search as day04
import gleam/int
import gleam/io
import gleam/result
import guard_gallivant as day06
import historian_hysteria as day01
import mull_it_over as day03
import print_queue as day05
import red_nosed_reports as day02
import simplifile.{read}

pub fn main() {
  //  Day 01
  result.unwrap(
    result.map(read("data/day1.txt"), fn(data) {
      io.println(
        "[1] Historian Hysteria (Part 1): "
        <> int.to_string(day01.solve_a(data)),
      )
      io.println(
        "[1] Historian Hysteria (Part 2): "
        <> int.to_string(day01.solve_b(data)),
      )
    }),
    Nil,
  )

  //  Day 02
  result.unwrap(
    result.map(read("data/day2.txt"), fn(data) {
      io.println(
        "[2] Red Nosed Reports (Part 1): " <> int.to_string(day02.solve_a(data)),
      )
      io.println(
        "[2] Red Nosed Reports (Part 2): " <> int.to_string(day02.solve_b(data)),
      )
    }),
    Nil,
  )

  //  Day 03
  result.unwrap(
    result.map(read("data/day3.txt"), fn(data) {
      io.println(
        "[3] Mull It Over (Part 1): " <> int.to_string(day03.solve_a(data)),
      )
      io.println(
        "[3] Mull It Over (Part 2): " <> int.to_string(day03.solve_b(data)),
      )
    }),
    Nil,
  )

  //  Day 04
  result.unwrap(
    result.map(read("data/day4.txt"), fn(data) {
      io.println(
        "[4] Ceres Search (Part 1): " <> int.to_string(day04.solve_a(data)),
      )
      io.println(
        "[4] Ceres Search (Part 2): " <> int.to_string(day04.solve_b(data)),
      )
    }),
    Nil,
  )

  //  Day 05
  result.unwrap(
    result.map(read("data/day5.txt"), fn(data) {
      io.println(
        "[5] Print Queue (Part 1): " <> int.to_string(day05.solve_a(data)),
      )
      io.println(
        "[5] Print Queue (Part 2): " <> int.to_string(day05.solve_b(data)),
      )
    }),
    Nil,
  )

  //  Day 06
  result.unwrap(
    result.map(read("data/day6.txt"), fn(data) {
      io.println(
        "[6] Guard Gallivant (Part 1): " <> int.to_string(day06.solve_a(data)),
      )
      io.println(
        "[6] Guard Gallivant (Part 2): skipped execution (runtime 9m30s)",
        // <> int.to_string(day06.solve_b(data)),
      )
    }),
    Nil,
  )
}
