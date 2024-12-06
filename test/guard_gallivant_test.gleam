import gleam/string
import gleeunit/should
import guard_gallivant as day05

fn test_data() {
  string.join(
    [
      "....#.....", ".........#", "..........", "..#.......", ".......#..",
      "..........", ".#..^.....", "........#.", "#.........", "......#...",
    ],
    "\n",
  )
}

pub fn solve_a_test() {
  should.equal(day05.solve_a(test_data()), 41)
}

pub fn solve_b_test() {
  should.equal(day05.solve_b(test_data()), 6)
}
