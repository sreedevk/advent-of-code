import gleam/int
import gleam/io
import gleam/list
import gleam/otp/task
import gleam/pair.{second as ps}
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

fn solve_eq_lr(eq: List(String)) -> List(String) {
  case list.length(eq) {
    1 -> eq
    _ -> {
      let #(head, tail) = list.split(eq, 3)
      let reduced = case head {
        [lhs, opr, rhs] ->
          case opr {
            "*" -> [int.to_string(int.multiply(parse_num(lhs), parse_num(rhs)))]
            "+" -> [int.to_string(int.add(parse_num(lhs), parse_num(rhs)))]
            "||" -> [string.join([lhs, rhs], "")]
            _ -> ["0"]
          }
        _ -> ["0"]
      }
      solve_eq_lr(list.append(reduced, tail))
    }
  }
}

fn is_satisfiable(eq: Equation, operators: List(String)) -> Bool {
  li.repeated_permutation(operators, list.length(eq.values) - 1)
  |> list.map(fn(combo) { list.interleave([eq.values, combo]) })
  |> list.flat_map(solve_eq_lr)
  |> list.any(fn(soln) { eq.target == parse_num(soln) })
}

pub fn solve_a(input: String) -> Int {
  parse_file(input)
  |> list.map(fn(eq) {
    task.async(fn() { #(eq, is_satisfiable(eq, ["*", "+"])) })
  })
  |> list.map(task.await_forever)
  |> list.filter_map(fn(x) {
    case x {
      #(eq, True) -> Ok(eq)
      _ -> Error(Nil)
    }
  })
  |> list.map(fn(x) { x.target })
  |> list.fold(0, int.add)
}

pub fn solve_b(input: String) -> Int {
  parse_file(input)
  |> list.map(fn(eq) {
    task.async(fn() { #(eq, is_satisfiable(eq, ["*", "+", "||"])) })
  })
  |> list.map(task.await_forever)
  |> list.filter_map(fn(x) {
    case x {
      #(eq, True) -> Ok(eq)
      _ -> Error(Nil)
    }
  })
  |> list.map(fn(x) { x.target })
  |> list.fold(0, int.add)
}
