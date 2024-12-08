# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../src/rock_paper_scissors'

class TestRockPaperScissors < Minitest::Test
  def data
    "A Y\nB X\nC Z\n"
  end

  def test_solve1
    assert_equal 15, RockPaperScissors.new(data).solve1
  end

  def test_solve2
    assert_equal 12, RockPaperScissors.new(data).solve2
  end
end
