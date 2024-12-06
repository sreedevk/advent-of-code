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

type Boundaries =
  #(Int, Int)

type State =
  #(Point, Direction, Grid, List(History), Boundaries, Bool)

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

fn init_state(g: Grid) -> State {
  let assert Ok(gp) = list.find(dict.keys(g), is_guard_position(_, g))
  let max_x = li.max(list.map(dict.keys(g), pf))
  let max_y = li.max(list.map(dict.keys(g), ps))

  #(gp, Up, g, [#(gp, Up)], #(max_x, max_y), False)
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

fn guard_exited(pos: Point, bounds: #(Int, Int)) -> Bool {
  let #(x, y) = pos
  let #(mx, my) = bounds
  x > mx || x < 0 || y < 0 || y > my
}

fn emulate(state: State) -> State {
  let #(gp, gd, g, vs, bounds, _) = state
  let #(ngp, ngd) = next_coordinates(gp, gd, g)
  case guard_exited(ngp, bounds) {
    True -> state
    False ->
      emulate(#(ngp, ngd, g, list.append(vs, [#(ngp, ngd)]), bounds, False))
  }
}

fn visited_count(st: State) -> Int {
  let #(_, _, _, hist, _, _) = st
  hist
  |> list.map(pf)
  |> list.unique()
  |> list.length()
}

fn visited_paths(st: State) -> #(Grid, List(Point)) {
  let #(_, _, g, hist, _, _) = st

  #(g, list.unique(list.map(hist, pf)))
}

fn iterate(state: State) -> State {
  let #(gp, gd, g, vs, bounds, _) = state
  let #(ngp, ngd) = next_coordinates(gp, gd, g)
  let ngh = list.append(vs, [#(ngp, ngd)])

  case guard_exited(ngp, bounds) {
    True -> state
    False ->
      case li.contains(vs, #(ngp, ngd)) {
        True -> #(ngp, ngd, g, ngh, bounds, True)
        False -> iterate(#(ngp, ngd, g, ngh, bounds, False))
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

fn computer_obst(g: Grid, point: Point) {
  task.async(fn() {
    case iterate(init_state(add_obst(g, point))) {
      #(_, _, _, _, _, r) -> r
    }
  })
}

fn computer_obst_all_var(info) -> Int {
  let #(g, original_path) = info

  original_path
  |> list.map(computer_obst(g, _))
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
  |> computer_obst_all_var
}
