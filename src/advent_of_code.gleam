import gleam/io
import gleam/result
import gleam/int
import historian_hysteria as day01
import simplifile.{read}

pub fn main() {
  //  Day 01
  result.map(read("data/day1.txt"), fn(data) {
    io.println("[1] Historian Hysteria (Part 1): " <> int.to_string(day01.solve_a(data)))
    io.println("[1] Historian Hysteria (Part 2): " <> int.to_string(day01.solve_b(data)))
  })
}
