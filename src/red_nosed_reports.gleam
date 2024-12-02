import gleam/int
import gleam/list
import gleam/pair
import gleam/result
import gleam/string

fn parse_line(line: String) -> List(Int) {
  use a <- list.map(string.split(line, " "))
  result.unwrap(int.parse(a), 0)
}

fn all_incr(report: List(Int)) -> Bool {
  use nums <- list.all(list.window_by_2(report))
  case pair.second(nums) - pair.first(nums) {
    x if x > 0 && x < 4 -> True
    _ -> False
  }
}

fn all_decr(report: List(Int)) -> Bool {
  use nums <- list.all(list.window_by_2(report))
  case pair.first(nums) - pair.second(nums) {
    x if x > 0 && x < 4 -> True
    _ -> False
  }
}

fn valid(report: List(Int), d: Bool) -> Bool {
  case d {
    False -> all_incr(report) || all_decr(report)
    True ->
      valid(report, False)
      || {
        report
        |> list.combinations(list.length(report) - 1)
        |> list.any(valid(_, False))
      }
  }
}

pub fn solve_a(input: String) -> Int {
  input
  |> string.trim()
  |> string.split("\n")
  |> list.map(parse_line)
  |> list.count(valid(_, False))
}

pub fn solve_b(input: String) -> Int {
  input
  |> string.trim()
  |> string.split("\n")
  |> list.map(parse_line)
  |> list.filter(valid(_, True))
  |> list.length()
}
