import gleam/result
import gleam/string
import gleam/list
import gleam/int
import gleam/pair

fn parse_line(line: String) -> List(Int) {
  use line <- list.map(string.split(line, "   "))
  result.unwrap(int.parse(line), 0)
}

fn dist(scans: #(Int, Int)) {
  int.absolute_value(pair.second(scans) - pair.first(scans))
}

pub fn solve_a(input) -> Int {
  input
  |> string.trim()
  |> string.split("\n") 
  |> list.map(parse_line)
  |> list.transpose()
  |> list.map(fn(x) { list.reverse(x) })
  |> list.map(fn(x) { list.sort(x, int.compare) })
  |> list.reduce(fn(x, y) { list.map(list.zip(x, y), dist) })
  |> result.unwrap([])
  |> list.reduce(int.add)
  |> result.unwrap(0)
}

fn similarity(x: Int, y: List(Int)) {
  x * list.count(y, fn(z) { x == z })
}

pub fn solve_b(input) -> Int {
  input
  |> string.trim()
  |> string.split("\n") 
  |> list.map(parse_line)
  |> list.transpose()
  |> list.map(fn(x) { list.reverse(x) })
  |> list.reduce(fn(x, y) { list.map(x, fn(item) { similarity(item, y) }) })
  |> result.unwrap([])
  |> list.reduce(int.add)
  |> result.unwrap(0)
}
