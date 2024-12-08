import gleam/string
import gleeunit/should
import resonant_collinearity as day08

fn test_data() -> String {
  string.join(
    [
      "............", "........0...", ".....0......", ".......0....",
      "....0.......", "......A.....", "............", "............",
      "........A...", ".........A..", "............", "............",
    ],
    "\n",
  )
}

pub fn solve_a_test() {
  should.equal(day08.solve_a(test_data()), 14)
}

pub fn solve_b_test() {
  should.equal(day08.solve_b(test_data()), 34)
}
