import gleam/dict.{type Dict}
import gleam/list
import gleam/option.{type Option, Some}
import gleam/otp/task
import gleam/pair
import gleam/result
import gleam/string
import utils/list as li

type Entity {
  Guard
  Obstacle
  UserObst
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
  #(Point, Direction, Grid, List(History), Boundaries)

type AdvState =
  #(State, Bool)

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

fn is_guard_position(position) -> Bool {
  case position {
    #(_, entity) if entity == Guard -> True
    _ -> False
  }
}

fn guard_position(grid: Grid) -> Result(Point, Nil) {
  dict.to_list(grid)
  |> list.find(is_guard_position)
  |> result.map(fn(set) { pair.first(set) })
}

fn init_state(g: Grid) -> State {
  let assert Ok(gp) = guard_position(g)
  #(gp, Up, g, [#(gp, Up)], #(max_x(g), max_y(g)))
}

fn init_adv_state(grid: Grid) -> AdvState {
  #(init_state(grid), False)
}

fn max_x(grid: Grid) -> Int {
  li.max(list.map(dict.keys(grid), pair.first))
}

fn max_y(grid: Grid) -> Int {
  li.max(list.map(dict.keys(grid), pair.second))
}

fn update_coordinates(position: Point, direction: Direction) -> Point {
  case direction {
    Up -> #(pair.first(position), pair.second(position) - 1)
    Down -> #(pair.first(position), pair.second(position) + 1)
    Left -> #(pair.first(position) - 1, pair.second(position))
    Right -> #(pair.first(position) + 1, pair.second(position))
  }
}

fn is_obstacle(position: Point, grid: Grid) -> Bool {
  case dict.get(grid, position) {
    Ok(Obstacle) | Ok(UserObst) -> True
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
  let np = update_coordinates(pos, dir)
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
  let #(gp, gd, g, vs, bounds) = state
  let #(ngp, ngd) = next_coordinates(gp, gd, g)
  case guard_exited(ngp, bounds) {
    True -> state
    False -> emulate(#(ngp, ngd, g, list.append(vs, [#(ngp, ngd)]), bounds))
  }
}

fn visited_count(st: State) -> Int {
  let #(_, _, _, hist, _) = st
  hist
  |> list.map(fn(x) { pair.first(x) })
  |> list.unique()
  |> list.length()
}

fn iterate(astate: AdvState) -> AdvState {
  let #(state, _) = astate
  let #(gp, gd, g, vs, bounds) = state
  let #(ngp, ngd) = next_coordinates(gp, gd, g)
  let ngh = list.append(vs, [#(ngp, ngd)])

  case guard_exited(ngp, bounds) {
    True -> #(state, False)
    False ->
      case li.contains(vs, #(ngp, ngd)) {
        True -> #(#(ngp, ngd, g, ngh, bounds), True)
        False -> iterate(#(#(ngp, ngd, g, ngh, bounds), False))
      }
  }
}

fn add_obst(g: Grid, pt: Point) -> Grid {
  dict.upsert(g, pt, fn(ent: Option(Entity)) {
    case ent {
      Some(Guard) -> Guard
      _ -> UserObst
    }
  })
}

fn computer_obst_chunk_var(g: Grid, points: List(Point)) -> List(Bool) {
  use obs_pos <- list.map(points)
  add_obst(g, obs_pos)
  |> init_adv_state
  |> iterate
  |> pair.second
}

fn computer_obst_all_var(g: Grid) -> Int {
  dict.keys(g)
  |> list.sized_chunk(5000)
  |> list.map(fn(pos_chunk) {
    task.async(fn() { computer_obst_chunk_var(g, pos_chunk) })
  })
  |> list.map(task.await_forever)
  |> list.flatten
  |> list.count(fn(x) { x })
}

pub fn solve_a(input: String) -> Int {
  parse_grid(input)
  |> init_state
  |> emulate
  |> visited_count
}

pub fn solve_b(input: String) -> Int {
  parse_grid(input)
  |> computer_obst_all_var
}
