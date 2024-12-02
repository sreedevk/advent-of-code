import gleam/string
import gleeunit/should
import red_nosed_reports as day01

fn test_data() -> String {
  string.join(
    [
      "7 6 4 2 1", "1 2 7 8 9", "9 7 6 2 1", "1 3 2 4 5", "8 6 4 4 1",
      "1 3 6 7 9",
    ],
    "\n",
  )
}

pub fn solve_a_test() {
  should.equal(day01.solve_a(test_data()), 2)
}

pub fn solve_b_test() {
  should.equal(day01.solve_b(test_data()), 4)
}
