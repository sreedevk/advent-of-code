import gleam/int
import gleam/io
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

fn valid(report: List(Int)) -> Bool {
  all_incr(report) || all_decr(report)
}

fn valid_after_dampener(report) -> Bool {
  case valid(report) {
    True -> True
    False -> {
      let indexed_list = list.index_map(report, fn(x, i) { #(i, x) })
      let range = list.range(0, list.length(indexed_list) - 1)
      let final_list =
        list.map(range, fn(rmi) {
          use #(_, flist) <- result.map(list.key_pop(indexed_list, rmi))
          list.map(flist, pair.second)
        })

      let ys = list.map(final_list, fn(y) { result.unwrap(y, []) })
      list.any(ys, fn(y) { valid(y) })
    }
  }
}

pub fn solve_a(input: String) -> Int {
  input
  |> string.trim()
  |> string.split("\n")
  |> list.map(parse_line)
  |> list.count(valid(_))
}

pub fn solve_b(input: String) -> Int {
  input
  |> string.trim()
  |> string.split("\n")
  |> list.map(parse_line)
  |> list.filter(valid_after_dampener(_))
  |> list.length()
}
