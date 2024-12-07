import bridge_repair as day07
import gleam/string
import gleeunit/should

fn test_data() -> String {
  string.join(
    [
      "190: 10 19", "3267: 81 40 27", "83: 17 5", "156: 15 6", "7290: 6 8 6 15",
      "161011: 16 10 13", "192: 17 8 14", "21037: 9 7 18 13", "292: 11 6 16 20",
    ],
    "\n",
  )
}

pub fn solve_a_test() {
  should.equal(day07.solve_a(test_data()), 3749)
}

pub fn solve_b_test() {
  should.equal(day07.solve_b(test_data()), 11_387)
}
