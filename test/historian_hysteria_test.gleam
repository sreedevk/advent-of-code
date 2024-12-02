import gleeunit/should
import historian_hysteria as day01

fn test_data() -> String {
  "3   4\n4   3\n2   5\n1   3\n3   9\n3   3"
}

pub fn solve_a_test() {
  should.equal(day01.solve_a(test_data()), 11)
}

pub fn solve_b_test() {
  should.equal(day01.solve_b(test_data()), 31)
}
