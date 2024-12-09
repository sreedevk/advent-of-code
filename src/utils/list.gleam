import gleam/list as li
import gleam/pair.{first as pf, second as ps}
import gleam/result as res

pub fn index(ls: List(a), item: a) -> Result(Int, Nil) {
  li.index_map(ls, fn(x, index) { #(index, x) })
  |> li.find(fn(x) { ps(x) == item })
  |> res.map(pf)
}

pub fn at(ls: List(a), i: Int) -> Result(a, Nil) {
  li.index_map(ls, fn(x, ci) { #(x, ci) })
  |> li.find(fn(x) { ps(x) == i })
  |> res.map(pf)
}

pub fn from_pair(p: #(a, a)) -> List(a) {
  [pf(p), ps(p)]
}

pub fn pop(ls: List(a)) -> #(Result(a, Nil), List(a)) {
  case at(ls, li.length(ls) - 1) {
    Ok(someval) -> {
      #(Ok(someval), li.take(ls, li.length(ls) - 2))
    }
    Error(_) -> #(Error(Nil), ls)
  }
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

pub fn max(ls: List(Int)) -> Int {
  li.fold(ls, 0, fn(cmx, cx) {
    case cx {
      cxx if cxx > cmx -> cxx
      _ -> cmx
    }
  })
}

pub fn repeated_permutation(ls: List(a), n: Int) {
  use acc, _ <- li.fold(li.range(1, n), [[]])
  use y <- li.flat_map(acc)
  use z <- li.map(ls)

  li.append(y, li.wrap(z))
}
