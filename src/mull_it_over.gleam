import gleam/int
import gleam/list
import gleam/pair
import gleam/regexp
import gleam/result

pub fn process_isr(instr: String) -> Int {
  let assert Ok(args_rex) = regexp.from_string("\\d{1,3}")
  regexp.scan(args_rex, instr)
  |> list.map(fn(x) { x.content })
  |> list.map(fn(x) { result.unwrap(int.parse(x), -1) })
  |> list.fold_right(1, int.multiply)
}

pub fn process_cond_isr(state: #(Bool, Int), instr: String) -> #(Bool, Int) {
  case instr {
    "do()" -> #(True, pair.second(state))
    "don't()" -> #(False, pair.second(state))
    _ ->
      case pair.first(state) {
        True -> #(True, int.add(process_isr(instr), pair.second(state)))
        False -> state
      }
  }
}

pub fn solve_a(input: String) -> Int {
  let assert Ok(rex) = regexp.from_string("(mul\\([0-9]{1,3},[0-9]{1,3}\\))")

  regexp.scan(rex, input)
  |> list.map(fn(match) { match.content })
  |> list.map(process_isr)
  |> list.reduce(int.add)
  |> result.unwrap(0)
}

pub fn solve_b(input: String) -> Int {
  let assert Ok(rex) =
    regexp.from_string("(mul\\([0-9]{1,3},[0-9]{1,3}\\)|do\\(\\))|don't\\(\\)")

  regexp.scan(rex, input)
  |> list.map(fn(match) { match.content })
  |> list.fold(#(True, 0), process_cond_isr)
  |> pair.second
}
