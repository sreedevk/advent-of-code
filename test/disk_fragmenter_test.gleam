import disk_fragmenter as day09
import gleeunit/should

pub fn solve_a_test() {
  should.equal(day09.solve_a("2333133121414131402"), 1928)
}

pub fn solve_b_test() {
  should.equal(day09.solve_b("2333133121414131402"), 0)
}
