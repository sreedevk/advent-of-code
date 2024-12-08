# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../src/treetop_tree_house'

# Day 3 2022
class TestSupplyStacks < Minitest::Test
  def data
    %w[30373 25512 65332 33549 35390].join("\n")
  end

  def test_solve1
    assert_equal 21, TreetopTreeHouse.new(data).solve1
  end

  def test_solve2
    assert_equal 8, TreetopTreeHouse.new(data).solve2
  end
end
