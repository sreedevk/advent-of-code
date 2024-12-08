import gleam/dict.{type Dict}
import gleam/float
import gleam/int
import gleam/list
import gleam/result
import gleam/string

type Point =
  #(Float, Float)

type Grid =
  Dict(Point, String)

type Direction {
  Forward
  Reverse
}

fn parse_column(line, y) {
  use grid, char, x <- list.index_fold(line, dict.new())
  dict.insert(grid, #(int.to_float(x), int.to_float(y)), char)
}

fn square(input: Float) -> Float {
  case float.power(input, 2.0) {
    Ok(val) -> val
    _ -> 0.0
  }
}

fn find_collinear_vector(
  point_a: Point,
  point_b: Point,
) -> #(Float, #(Float, Float)) {
  let #(x1, y1) = point_a
  let #(x2, y2) = point_b

  let assert Ok(distance) =
    float.add(square(float.subtract(x2, x1)), square(float.subtract(y2, y1)))
    |> float.square_root

  let assert Ok(dx) = float.divide(float.subtract(x2, x1), distance)
  let assert Ok(dy) = float.divide(float.subtract(y2, y1), distance)

  #(distance, #(dx, dy))
}

fn find_collinear_in_direction(
  points: List(Point),
  direction: Direction,
) -> Point {
  let assert [point_a, point_b] = points
  let #(distance, #(dx, dy)) = find_collinear_vector(point_a, point_b)
  let #(x1, y1) = point_a
  let #(x2, y2) = point_b

  case direction {
    Forward -> #(
      float.ceiling(float.add(x2, float.multiply(dx, distance))),
      float.ceiling(float.add(y2, float.multiply(dy, distance))),
    )
    Reverse -> #(
      float.ceiling(float.subtract(x1, float.multiply(dx, distance))),
      float.ceiling(float.subtract(y1, float.multiply(dy, distance))),
    )
  }
}

fn find_harmonic_collinear_in_direction(
  found: List(Point),
  grid: Grid,
  direction: Direction,
) -> List(Point) {
  let #(head, rest) = list.split(found, 2)
  let assert [p1, p2] = head
  let collinear_in_direction = find_collinear_in_direction(head, direction)

  case point_within_map(collinear_in_direction, grid) {
    True ->
      case direction {
        Forward ->
          find_harmonic_collinear_in_direction(
            list.append([p2, collinear_in_direction], list.append(rest, [p1])),
            grid,
            direction,
          )
        Reverse ->
          find_harmonic_collinear_in_direction(
            list.append([collinear_in_direction, p1], list.append(rest, [p2])),
            grid,
            direction,
          )
      }
    False -> found
  }
}

fn find_all_harmonic_collinears(points: List(Point), grid: Grid) -> List(Point) {
  list.append(
    find_harmonic_collinear_in_direction(points, grid, Forward),
    find_harmonic_collinear_in_direction(points, grid, Reverse),
  )
}

fn find_all_collinears(points: List(Point)) -> List(Point) {
  list.wrap(find_collinear_in_direction(points, Forward))
  |> list.append(list.wrap(find_collinear_in_direction(points, Reverse)))
}

fn find_antenna_locations(antenna: String, grid: Grid) -> List(Point) {
  dict.keys(dict.filter(grid, fn(_, ant) { ant == antenna }))
}

fn point_within_map(point: Point, g: Grid) -> Bool {
  result.is_ok(list.find(dict.keys(g), fn(x) { x == point }))
}

fn collinears_for_antenna(antenna: String, g: Grid) -> List(Point) {
  find_antenna_locations(antenna, g)
  |> list.combinations(2)
  |> list.flat_map(find_all_collinears)
  |> list.filter(point_within_map(_, g))
  |> list.unique
}

fn harmonic_collinears_for_antenna(antenna: String, g: Grid) -> List(Point) {
  find_antenna_locations(antenna, g)
  |> list.combinations(2)
  |> list.flat_map(find_all_harmonic_collinears(_, g))
  |> list.filter(point_within_map(_, g))
}

fn parse_input(input: String) -> Grid {
  input
  |> string.trim()
  |> string.split("\n")
  |> list.map(string.to_graphemes)
  |> list.index_map(parse_column)
  |> list.fold(dict.new(), dict.merge)
}

pub fn solve_a(input: String) -> Int {
  let grid = parse_input(input)

  list.filter(list.unique(dict.values(grid)), fn(x) { x != "." })
  |> list.map(collinears_for_antenna(_, grid))
  |> list.flatten
  |> list.unique
  |> list.length
}

pub fn solve_b(input: String) -> Int {
  let grid = parse_input(input)

  list.filter(list.unique(dict.values(grid)), fn(x) { x != "." })
  |> list.map(harmonic_collinears_for_antenna(_, grid))
  |> list.flatten
  |> list.unique
  |> list.length
}
