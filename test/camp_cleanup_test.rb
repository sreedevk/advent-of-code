# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../src/camp_cleanup'

class TestCampCleanup < Minitest::Test
  def data
    ['2-4,6-8', '2-3,4-5', '5-7,7-9', '2-8,3-7', '6-6,4-6', '2-6,4-8'].join("\n")
  end

  def test_solve1
    assert_equal 2, CampCleanup.new(data).solve1
  end

  def test_solve2
    assert_equal 4, CampCleanup.new(data).solve2
  end
end
