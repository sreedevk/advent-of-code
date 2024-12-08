# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../src/supply_stacks'

# Day 3 2022
class TestSupplyStacks < Minitest::Test
  def data
    ['    [D]    ', '[N] [C]    ', '[Z] [M] [P]', ' 1   2   3 ', '', 'move 1 from 2 to 1', 'move 3 from 1 to 3',
     'move 2 from 2 to 1', 'move 1 from 1 to 2'].join("\n")
  end

  def test_solve1
    assert_equal 'CMZ', SupplyStacks.new(data).solve1
  end

  def test_solve2
    assert_equal 'MCD', SupplyStacks.new(data).solve2
  end
end
