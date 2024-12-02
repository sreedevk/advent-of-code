import gleam/int
import gleam/list
import gleam/pair
import gleam/result
import gleam/string

fn parse_line(line: String) -> List(Int) {
  use a <- list.map(string.split(line, "   "))
  result.unwrap(int.parse(a), 0)
}

fn dist(scans: #(Int, Int)) {
  int.absolute_value(pair.second(scans) - pair.first(scans))
}

fn freq_score_gen(ys: List(Int)) {
  fn(x) { x * list.count(ys, fn(y) { y == x }) }
}

pub fn solve_a(input) -> Int {
  input
  |> string.trim()
  |> string.split("\n")
  |> list.map(parse_line)
  |> list.transpose()
  |> list.map(list.sort(_, int.compare))
  |> list.reduce(fn(x, y) { list.map(list.zip(x, y), dist) })
  |> result.map(list.reduce(_, int.add))
  |> result.flatten()
  |> result.unwrap(0)
}

pub fn solve_b(input) -> Int {
  input
  |> string.trim()
  |> string.split("\n")
  |> list.map(parse_line)
  |> list.transpose()
  |> list.reduce(fn(x, y) { list.map(x, freq_score_gen(y)) })
  |> result.map(list.reduce(_, int.add))
  |> result.flatten()
  |> result.unwrap(0)
}
