# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../src/tuning_trouble'

# Day 3 2022
class TestTuningTrouble < Minitest::Test
  def data
    'zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw'
  end

  def test_solve1
    assert_equal 11, TuningTrouble.new(data).solve1
  end

  def test_solve2
    assert_equal 26, TuningTrouble.new(data).solve2
  end
end
