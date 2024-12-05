import gleam/list as li
import gleam/pair.{first as pf, second as ps}
import gleam/result as res

pub fn index(ls: List(a), item: a) -> Result(Int, Nil) {
  li.index_map(ls, fn(x, index) { #(index, x) })
  |> li.find(fn(x) { ps(x) == item })
  |> res.map(pf)
}

pub fn from_pair(p: #(a, a)) -> List(a) {
  [pf(p), ps(p)]
}

pub fn index_filter(ls: List(a), f: fn(Int, a) -> Bool) -> List(a) {
  li.index_map(ls, fn(item, index) { #(index, item) })
  |> li.filter(fn(x) { f(pf(x), ps(x)) })
  |> li.map(ps)
}

pub fn contains(ls: List(a), item: a) -> Bool {
  res.is_ok(li.find(ls, fn(x) { x == item }))
}

pub fn swap(ls: List(a), ea: a, eb: a) -> List(a) {
  use x <- li.map(ls)
  case x {
    val if val == ea -> eb
    val if val == eb -> ea
    val -> val
  }
}
