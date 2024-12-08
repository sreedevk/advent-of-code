# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../src/no_space_left_on_device'

class TestCampCleanup < Minitest::Test
  def data
    [
      '$ cd /',
      '$ ls',
      'dir a',
      '14848514 b.txt',
      '8504156 c.dat',
      'dir d',
      '$ cd a',
      '$ ls',
      'dir e',
      '29116 f',
      '2557 g',
      '62596 h.lst',
      '$ cd e',
      '$ ls',
      '584 i',
      '$ cd ..',
      '$ cd ..',
      '$ cd d',
      '$ ls',
      '4060174 j',
      '8033020 d.log',
      '5626152 d.ext',
      '7214296 k'
    ].join("\n")
  end

  def setup
    @solver = NoSpaceLeftOnDevice.new(data)
    @solution1 = @solver.solve1
    @solution2 = @solver.solve2
  end

  def test_solve1
    assert_equal 95_437, @solution1
  end

  def test_solve2
    assert_equal 24_933_642, @solution2
  end
end
