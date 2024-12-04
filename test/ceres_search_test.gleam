import ceres_search as day04
import gleam/string
import gleeunit/should

fn test_data() -> String {
  string.join(
    [
      "MMMSXXMASM", "MSAMXMSMSA", "AMXSXMAAMM", "MSAMASMSMX", "XMASAMXAMM",
      "XXAMMXXAMA", "SMSMSASXSS", "SAXAMASAAA", "MAMMMXMMMM", "MXMXAXMASX",
    ],
    "\n",
  )
}

pub fn solve_a_test() {
  should.equal(day04.solve_a(test_data()), 18)
}

pub fn solve_b_test() {
  should.equal(day04.solve_b(test_data()), 9)
}
