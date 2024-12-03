import gleeunit/should
import mull_it_over as day03

pub fn solve_a_test() {
  "xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))"
  |> day03.solve_a()
  |> should.equal(161)
}

pub fn solve_b_test() {
  "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))"
  |> day03.solve_b()
  |> should.equal(48)
}
