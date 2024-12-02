import gleam/int
import gleam/io
import gleam/result
import historian_hysteria as day01
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
}
