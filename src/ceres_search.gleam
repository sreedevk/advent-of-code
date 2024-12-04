import gleam/dict.{type Dict}
import gleam/int
import gleam/list
import gleam/pair
import gleam/result
import gleam/string

type Point =
  #(Int, Int)

type Grid =
  Dict(Point, String)

fn process_grid(input: String, f: fn(Grid) -> Int) -> Int {
  input
  |> string.trim()
  |> string.split("\n")
  |> list.map(string.to_graphemes)
  |> list.index_map(fn(line, y) {
    use grid, char, x <- list.index_fold(line, dict.new())
    dict.insert(grid, #(x, y), char)
  })
  |> list.reduce(dict.merge)
  |> result.unwrap(dict.new())
  |> f
}

fn word(points: List(Point), grid: Grid) -> String {
  use word, point <- list.fold(points, "")
  string.append(word, result.unwrap(dict.get(grid, point), ""))
}

fn all_neighbors(point: Point, word: String) -> List(List(Point)) {
  let id = fn(x, _d) { x }
  use f <- list.map([
    #(int.add, id),
    #(int.subtract, id),
    #(id, int.subtract),
    #(id, int.add),
    #(int.subtract, int.subtract),
    #(int.add, int.subtract),
    #(int.subtract, int.add),
    #(int.add, int.add),
  ])
  use d <- list.map(list.range(0, string.length(word) - 1))
  let #(x, y) = point
  #(pair.first(f)(x, d), pair.second(f)(y, d))
}

fn x_neighbors(point: #(Int, Int)) {
  let #(x, y) = point
  [
    [#(x - 1, y - 1), point, #(x + 1, y + 1)],
    [#(x + 1, y - 1), point, #(x - 1, y + 1)],
  ]
}

fn xmas_count_at_point(grid: Grid, point: Point) -> Int {
  all_neighbors(point, "XMAS")
  |> list.map(word(_, grid))
  |> list.count(fn(w) { w == "XMAS" })
}

fn point_has_x_mas(grid: Grid, point: Point) -> Bool {
  x_neighbors(point)
  |> list.map(word(_, grid))
  |> list.all(fn(w) { w == "MAS" || w == "SAM" })
}

pub fn solve_a(input: String) -> Int {
  use grid <- process_grid(input)

  dict.keys(grid)
  |> list.map(xmas_count_at_point(grid, _))
  |> list.fold(0, int.add)
}

pub fn solve_b(input: String) -> Int {
  use grid <- process_grid(input)

  dict.keys(grid)
  |> list.count(point_has_x_mas(grid, _))
}
