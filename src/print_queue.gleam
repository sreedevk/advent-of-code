import gleam/int
import gleam/io
import gleam/list
import gleam/pair
import gleam/result
import gleam/string

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

fn contains(ls: List(a), item: a) -> Bool {
  result.is_ok(list.find(ls, fn(x) { x == item }))
}

fn filter_with_index(ls: List(a), f: fn(Int, a) -> Bool) -> List(a) {
  list.index_map(ls, fn(item, index) { #(index, item) })
  |> list.filter(fn(x) { f(pair.first(x), pair.second(x)) })
  |> list.map(fn(y) { pair.second(y) })
}

fn at(ls: List(a), idx: Int) -> Result(a, Nil) {
  list.index_map(ls, fn(item, index) { #(index, item) })
  |> list.find(fn(x) { pair.first(x) == idx })
  |> result.map(fn(res) { pair.second(res) })
}

fn rule_applicable(order: Order, rule: Rule) -> Bool {
  let #(x, y) = rule
  contains(order, x) && contains(order, y)
}

fn index(ls: List(a), item: a) -> Result(Int, Nil) {
  list.index_map(ls, fn(x, index) { #(index, x) })
  |> list.find(fn(x) { pair.second(x) == item })
  |> result.map(fn(x) { pair.first(x) })
}

fn rule_satisfied(order: Order, rule: Rule) -> Bool {
  let #(rf, rs) = rule
  let assert [x, y] = list.filter(order, fn(x) { x == rf || x == rs })

  x == rf && y == rs
}

fn order_follows_rules(order: Order, rules: List(Rule)) -> Bool {
  rules
  |> list.filter(rule_applicable(order, _))
  |> list.all(fn(rule) { rule_satisfied(order, rule) })
}

fn make_order_follow_rules(order: Order, rules: List(Rule)) -> Order {
  rules
  |> list.filter(rule_applicable(order, _))
  |> list.fold(order, fn(oc, rule) {
    case rule_satisfied(oc, rule) {
      True -> oc
      False -> swap(oc, pair.first(rule), pair.second(rule))
    }
  })
  |> fn(oc) {
    case order_follows_rules(oc, rules) {
      True -> oc
      False -> make_order_follow_rules(oc, rules)
    }
  }
}

fn middle(order: Order) -> Int {
  order
  |> at(list.length(order) / 2)
  |> result.unwrap(0)
}

fn swap(ls: List(a), ea: a, eb: a) -> List(a) {
  list.map(ls, fn(x) {
    case x {
      val if val == ea -> eb
      val if val == eb -> ea
      val -> val
    }
  })
}

pub fn solve_a(input: String) -> Int {
  let #(rules, orders) = parse_file(input)

  orders
  |> list.filter(fn(order) { order_follows_rules(order, rules) })
  |> list.map(middle)
  |> list.fold(0, int.add)
}

pub fn solve_b(input: String) -> Int {
  let #(rules, orders) = parse_file(input)

  orders
  |> list.filter(fn(order) { !order_follows_rules(order, rules) })
  |> list.map(fn(order) { make_order_follow_rules(order, rules) })
  |> list.map(middle)
  |> list.fold(0, int.add)
}
