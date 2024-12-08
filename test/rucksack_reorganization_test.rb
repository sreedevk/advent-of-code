# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../src/rucksack_reorganization'

# Day 3 2022
class TestRucksackReorganization < Minitest::Test
  def data
    %w[vJrwpWtwJgWrhcsFMMfFFhFp jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL PmmdzqPrVvPwwTWBwg
       wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn ttgJtRGJQctTZtZT CrZsJsPPZsGzwwsLwLmpwMDw].join("\n")
  end

  def test_solve1
    assert_equal 157, RucksackReorganization.new(data).solve1
  end

  def test_solve2
    assert_equal 70, RucksackReorganization.new(data).solve2
  end
end
