import gleam/string
import gleeunit/should
import hoof_it as day10

fn test_data() -> String {
  string.join(
    [
      "89010123", "78121874", "87430965", "96549874", "45678903", "32019012",
      "01329801", "10456732",
    ],
    "\n",
  )
}

pub fn solve_a_test() {
  should.equal(day10.solve_a(test_data()), 36)
}

pub fn solve_b_test() {
  should.equal(day10.solve_b(test_data()), 0)
}
