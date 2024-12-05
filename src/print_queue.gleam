import gleam/bool
import gleam/int
import gleam/list
import gleam/pair.{first as pf, second as ps}
import gleam/result
import gleam/string
import gleam/yielder
import utils/list as li

type Rule =
  #(Int, Int)

type Order =
  List(Int)

fn parse_rule(input: String) -> Rule {
  let assert Ok(#(first, second)) = string.split_once(input, "|")
  let assert Ok(fnum) = int.parse(first)
  let assert Ok(snum) = int.parse(second)

  #(fnum, snum)
}

fn parse_order(input: String) -> List(Int) {
  use numres <- list.map(string.split(input, ","))

  result.unwrap(int.parse(numres), 0)
}

fn parse_file(input: String) -> #(List(Rule), List(Order)) {
  let assert Ok(#(rules, orders)) =
    string.split_once(string.trim(input), "\n\n")

  let parsed_rules = list.map(string.split(rules, "\n"), parse_rule)
  let parsed_orders = list.map(string.split(orders, "\n"), parse_order)
  #(parsed_rules, parsed_orders)
}

fn rule_applicable(order: Order, rule: Rule) -> Bool {
  list.all(li.from_pair(rule), li.contains(order, _))
}

fn rule_satisfied(order: Order, rule: Rule) -> Bool {
  let #(rf, rs) = rule
  let assert [x, y] = list.filter(order, fn(x) { x == rf || x == rs })

  x == rf && y == rs
}

fn order_follows_rules(order: Order, rules: List(Rule)) -> Bool {
  rules
  |> list.filter(rule_applicable(order, _))
  |> list.all(rule_satisfied(order, _))
}

fn rule_satisfied_or_swap(order: Order, rule: Rule) -> Order {
  case rule_satisfied(order, rule) {
    True -> order
    False -> li.swap(order, pf(rule), ps(rule))
  }
}

fn make_order_follow_rules(order: Order, rules: List(Rule)) -> Order {
  case order_follows_rules(order, rules) {
    True -> order
    False -> {
      list.filter(rules, rule_applicable(order, _))
      |> list.fold(order, rule_satisfied_or_swap)
      |> make_order_follow_rules(rules)
    }
  }
}

fn middle(order: Order) -> Int {
  order
  |> yielder.from_list
  |> yielder.at(list.length(order) / 2)
  |> result.unwrap(0)
}

pub fn solve_a(input: String) -> Int {
  let #(rules, orders) = parse_file(input)

  orders
  |> list.filter(order_follows_rules(_, rules))
  |> list.map(middle)
  |> list.fold(0, int.add)
}

pub fn solve_b(input: String) -> Int {
  let #(rules, orders) = parse_file(input)

  orders
  |> list.filter(fn(order) { bool.negate(order_follows_rules(order, rules)) })
  |> list.map(make_order_follow_rules(_, rules))
  |> list.map(middle)
  |> list.fold(0, int.add)
}
