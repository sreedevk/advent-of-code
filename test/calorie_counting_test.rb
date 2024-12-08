# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../src/calorie_counting'

class TestCalorieCounting < Minitest::Test
  def data
    "1000\n2000\n3000\n\n4000\n\n5000\n6000\n\n7000\n8000\n9000\n\n10000\n"
  end

  def test_solve1
    assert_equal 24_000, CalorieCounting.new(data).solve1
  end

  def test_solve2
    assert_equal 45_000, CalorieCounting.new(data).solve2
  end
end
