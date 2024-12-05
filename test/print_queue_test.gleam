import gleam/string
import gleeunit/should
import print_queue as day05

fn test_data() -> String {
  string.join(
    [
      string.join(
        [
          "47|53", "97|13", "97|61", "97|47", "75|29", "61|13", "75|53", "29|13",
          "97|29", "53|29", "61|53", "97|53", "61|29", "47|13", "75|47", "97|75",
          "47|61", "75|61", "47|29", "75|13", "53|13",
        ],
        "\n",
      ),
      string.join(
        [
          "75,47,61,53,29", "97,61,53,29,13", "75,29,13", "75,97,47,61,53",
          "61,13,29", "97,13,75,29,47",
        ],
        "\n",
      ),
    ],
    "\n\n",
  )
}

pub fn solve_a_test() {
  test_data()
  |> day05.solve_a()
  |> should.equal(143)
}

pub fn solve_b_test() {
  test_data()
  |> day05.solve_b()
  |> should.equal(123)
}
