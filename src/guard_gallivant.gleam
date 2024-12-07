import gleam/dict.{type Dict}
import gleam/list
import gleam/option.{type Option, Some}
import gleam/otp/task
import gleam/pair.{first as pf, second as ps}
import gleam/result
import gleam/string
import utils/list as li

type Entity {
  Guard
  Obstacle
  Path
  Unknown(String)
}

type Point =
  #(Int, Int)

type Grid =
  Dict(Point, Entity)

type Direction {
  Up
  Down
  Left
  Right
}

type History =
  #(Point, Direction)

type IterState {
  IterState(
    point: Point,
    direction: Direction,
    grid: Grid,
    histories: List(History),
    max_bound: Int,
    looping: Bool,
  )
}

fn parse_column(line, y) {
  use grid, char, x <- list.index_fold(line, dict.new())
  dict.insert(grid, #(x, y), case char {
    "." -> Path
    "#" -> Obstacle
    "^" -> Guard
    uchr -> Unknown(uchr)
  })
}

fn parse_grid(input: String) -> Grid {
  input
  |> string.trim()
  |> string.split("\n")
  |> list.map(string.to_graphemes)
  |> list.index_map(parse_column)
  |> list.reduce(dict.merge)
  |> result.unwrap(dict.new())
}

fn is_guard_position(pos: Point, g: Grid) -> Bool {
  case dict.get(g, pos) {
    Ok(Guard) -> True
    _ -> False
  }
}

fn init_state(g: Grid) -> IterState {
  let assert Ok(gp) = list.find(dict.keys(g), is_guard_position(_, g))
  IterState(
    point: gp,
    direction: Up,
    grid: g,
    histories: [#(gp, Up)],
    max_bound: li.max(list.map(dict.keys(g), pf)),
    looping: False,
  )
}

fn incr_pos(pos: Point, dir: Direction) -> Point {
  case dir {
    Up -> #(pf(pos), ps(pos) - 1)
    Down -> #(pf(pos), ps(pos) + 1)
    Left -> #(pf(pos) - 1, ps(pos))
    Right -> #(pf(pos) + 1, ps(pos))
  }
}

fn is_obstacle(position: Point, grid: Grid) -> Bool {
  case dict.get(grid, position) {
    Ok(Obstacle) -> True
    _ -> False
  }
}

fn rotate_cw(d: Direction) -> Direction {
  case d {
    Up -> Right
    Down -> Left
    Right -> Down
    Left -> Up
  }
}

fn next_coordinates(pos: Point, dir: Direction, g: Grid) -> #(Point, Direction) {
  let np = incr_pos(pos, dir)
  case is_obstacle(np, g) {
    True -> next_coordinates(pos, rotate_cw(dir), g)
    False -> #(np, dir)
  }
}

fn guard_exited(pos: Point, b: Int) -> Bool {
  let #(x, y) = pos
  x > b || x < 0 || y < 0 || y > b
}

fn emulate(is: IterState) -> IterState {
  let #(ngp, ngd) = next_coordinates(is.point, is.direction, is.grid)
  case guard_exited(ngp, is.max_bound) {
    True -> is
    False ->
      emulate(IterState(
        point: ngp,
        direction: ngd,
        grid: is.grid,
        histories: list.append(is.histories, [#(ngp, ngd)]),
        max_bound: is.max_bound,
        looping: False,
      ))
  }
}

fn visited_count(is: IterState) -> Int {
  is.histories
  |> list.map(pf)
  |> list.unique
  |> list.length
}

fn visited_paths(is: IterState) -> #(Grid, List(Point)) {
  #(is.grid, list.unique(list.map(is.histories, pf)))
}

fn iterate(is: IterState) -> IterState {
  let #(ngp, ngd) = next_coordinates(is.point, is.direction, is.grid)
  let ngh = list.append(is.histories, [#(ngp, ngd)])

  case guard_exited(ngp, is.max_bound) {
    True -> is
    False ->
      case li.contains(is.histories, #(ngp, ngd)) {
        True ->
          IterState(
            point: ngp,
            direction: ngd,
            grid: is.grid,
            histories: ngh,
            max_bound: is.max_bound,
            looping: True,
          )
        False ->
          iterate(IterState(
            point: ngp,
            direction: ngd,
            grid: is.grid,
            histories: ngh,
            max_bound: is.max_bound,
            looping: False,
          ))
      }
  }
}

fn add_obst(g: Grid, pt: Point) -> Grid {
  dict.upsert(g, pt, fn(ent: Option(Entity)) {
    case ent {
      Some(Guard) -> Guard
      _ -> Obstacle
    }
  })
}

fn is_infinite_loop_obstacle(g: Grid, point: Point) {
  task.async(fn() {
    add_obst(g, point)
    |> init_state
    |> iterate
    |> fn(x) { x.looping }
  })
}

fn count_infinite_loop_obstacles(info) -> Int {
  let #(g, original_path) = info

  original_path
  |> list.map(is_infinite_loop_obstacle(g, _))
  |> list.count(task.await_forever)
}

pub fn solve_a(input: String) -> Int {
  parse_grid(input)
  |> init_state
  |> emulate
  |> visited_count
}

pub fn solve_b(input: String) -> Int {
  parse_grid(input)
  |> init_state
  |> emulate
  |> visited_paths
  |> count_infinite_loop_obstacles
}
