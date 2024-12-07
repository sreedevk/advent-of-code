import gleam/int
import gleam/list
import gleam/otp/task
import gleam/result
import gleam/string
import utils/list as li

type Equation {
  Equation(target: Int, values: List(String))
}

fn parse_eq(line: String) -> Equation {
  let assert Ok(#(tar_str, vals_str)) = string.split_once(line, ": ")
  let assert Ok(tar_int) = int.parse(tar_str)
  let values = string.split(vals_str, " ")

  Equation(target: tar_int, values: values)
}

fn parse_file(input: String) -> List(Equation) {
  input
  |> string.trim
  |> string.split("\n")
  |> list.map(parse_eq)
}

fn parse_num(x: String) -> Int {
  result.unwrap(int.parse(x), 0)
}

fn mult(lhs: String, rhs: String) -> String {
  int.to_string(int.multiply(parse_num(lhs), parse_num(rhs)))
}

fn add(lhs: String, rhs: String) -> String {
  int.to_string(int.add(parse_num(lhs), parse_num(rhs)))
}

fn solve_part(eq: List(String)) -> List(String) {
  case eq {
    [lhs, opr, rhs] ->
      case opr {
        "*" -> list.wrap(mult(lhs, rhs))
        "+" -> list.wrap(add(lhs, rhs))
        "|" -> list.wrap(lhs <> rhs)
        _ -> []
      }
    _ -> []
  }
}

fn solve_eq_lr(eq: List(String)) -> List(String) {
  case list.length(eq) {
    1 | 0 -> eq
    _ -> {
      case list.split(eq, 3) {
        #(head, tail) -> solve_eq_lr(list.append(solve_part(head), tail))
      }
    }
  }
}

fn is_satisfiable(eq: Equation, operators: List(String)) -> Bool {
  li.repeated_permutation(operators, list.length(eq.values) - 1)
  |> list.map(fn(combo) { list.interleave([eq.values, combo]) })
  |> list.flat_map(solve_eq_lr)
  |> list.any(fn(soln) { eq.target == parse_num(soln) })
}

fn extract(x: #(Equation, Bool)) {
  case x {
    #(eq, True) -> Ok(eq.target)
    _ -> Error(Nil)
  }
}

fn is_satisfiable_async(eq: Equation, operators: List(String)) {
  task.async(fn() { #(eq, is_satisfiable(eq, operators)) })
}

pub fn solve_a(input: String) -> Int {
  parse_file(input)
  |> list.map(is_satisfiable_async(_, ["*", "+"]))
  |> list.map(task.await_forever)
  |> list.filter_map(extract)
  |> list.fold(0, int.add)
}

pub fn solve_b(input: String) -> Int {
  parse_file(input)
  |> list.map(is_satisfiable_async(_, ["*", "+", "|"]))
  |> list.map(task.await_forever)
  |> list.filter_map(extract)
  |> list.fold(0, int.add)
}
