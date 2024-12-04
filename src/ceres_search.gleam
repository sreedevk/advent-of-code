import gleam/dict.{type Dict}
import gleam/int
import gleam/io
import gleam/list
import gleam/pair
import gleam/result
import gleam/string

type Point =
  #(Int, Int)

type Grid =
  Dict(#(Int, Int), String)

fn parse_grid(input: String) -> Grid {
  input
  |> string.trim()
  |> string.split("\n")
  |> list.map(string.to_graphemes)
  |> list.index_map(fn(line, y) {
    list.index_fold(line, dict.new(), fn(grid, char, x) {
      dict.insert(grid, #(x, y), char)
    })
  })
  |> list.reduce(dict.merge)
  |> result.unwrap(dict.new())
}

fn forward(point: Point) -> List(Point) {
  [
    point,
    #(pair.first(point) + 1, pair.second(point)),
    #(pair.first(point) + 2, pair.second(point)),
    #(pair.first(point) + 3, pair.second(point)),
  ]
}

fn backward(point: Point) -> List(Point) {
  [
    point,
    #(pair.first(point) - 1, pair.second(point)),
    #(pair.first(point) - 2, pair.second(point)),
    #(pair.first(point) - 3, pair.second(point)),
  ]
}

fn upward(point: Point) -> List(Point) {
  [
    point,
    #(pair.first(point), pair.second(point) - 1),
    #(pair.first(point), pair.second(point) - 2),
    #(pair.first(point), pair.second(point) - 3),
  ]
}

fn downward(point: Point) -> List(Point) {
  [
    point,
    #(pair.first(point), pair.second(point) + 1),
    #(pair.first(point), pair.second(point) + 2),
    #(pair.first(point), pair.second(point) + 3),
  ]
}

fn upward_left(point: Point) -> List(Point) {
  [
    point,
    #(pair.first(point) - 1, pair.second(point) - 1),
    #(pair.first(point) - 2, pair.second(point) - 2),
    #(pair.first(point) - 3, pair.second(point) - 3),
  ]
}

fn upward_right(point: Point) -> List(Point) {
  [
    point,
    #(pair.first(point) + 1, pair.second(point) - 1),
    #(pair.first(point) + 2, pair.second(point) - 2),
    #(pair.first(point) + 3, pair.second(point) - 3),
  ]
}

fn downward_left(point: Point) -> List(Point) {
  [
    point,
    #(pair.first(point) - 1, pair.second(point) + 1),
    #(pair.first(point) - 2, pair.second(point) + 2),
    #(pair.first(point) - 3, pair.second(point) + 3),
  ]
}

fn downward_right(point: Point) -> List(Point) {
  [
    point,
    #(pair.first(point) + 1, pair.second(point) + 1),
    #(pair.first(point) + 2, pair.second(point) + 2),
    #(pair.first(point) + 3, pair.second(point) + 3),
  ]
}

fn neighbors(point: Point) -> List(List(Point)) {
  [
    forward(point),
    backward(point),
    upward(point),
    downward(point),
    upward_left(point),
    upward_right(point),
    downward_left(point),
    downward_right(point),
  ]
}

fn x_neighbors(point: Point) -> List(List(Point)) {
  [
    [
      #(pair.first(point) - 1, pair.second(point) - 1),
      point,
      #(pair.first(point) + 1, pair.second(point) + 1),
    ],
    [
      #(pair.first(point) + 1, pair.second(point) - 1),
      point,
      #(pair.first(point) - 1, pair.second(point) + 1),
    ],
  ]
}

fn fetch(points: List(Point), grid: Grid) -> String {
  list.fold(points, "", fn(word, point) {
    result.unwrap(dict.get(grid, point), "")
    |> string.append(word)
  })
}

fn word_count_at_point(grid: Grid, point: Point) -> Int {
  neighbors(point)
  |> list.map(fetch(_, grid))
  |> list.count(fn(word) { word == "XMAS" })
}

fn point_has_x_mas(grid: Grid, point: Point) -> Bool {
  x_neighbors(point)
  |> list.map(fetch(_, grid))
  |> list.all(fn(word) { word == "MAS" || word == "SAM" })
}

fn process_grid_xmas(grid: Grid) -> Int {
  dict.keys(grid)
  |> list.map(fn(point) { word_count_at_point(grid, point) })
  |> list.reduce(int.add)
  |> result.unwrap(0)
}

fn process_grid_x_mas(grid: Grid) -> Int {
  dict.keys(grid)
  |> list.count(fn(point) { point_has_x_mas(grid, point) })
}

pub fn solve_a(input: String) -> Int {
  parse_grid(input)
  |> process_grid_xmas()
}

pub fn solve_b(input: String) -> Int {
  parse_grid(input)
  |> process_grid_x_mas()
}
