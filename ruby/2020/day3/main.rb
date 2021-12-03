# frozen_string_literal: true

require 'pry'

class TobogganTrajectory
  X = :x; Y = :y

  def terrain
    @terrain ||= ARGF.readlines.map(&:strip).map(&:chars)
  end

  def traverse(path_pattern, state={x: 0, y: 0, trees: 0})
    updated_state = {
      x: (state[X] + path_pattern[0]) % max_x,
      y: state[Y] + path_pattern[1],
      trees: tree?(terrain.dig(state[Y], state[X])) ? (state[:trees] + 1) : state[:trees]
    }
    return updated_state unless terrain.dig(updated_state[Y])

    traverse(path_pattern, updated_state)
  end

  def part1
    traverse([3, 1])[:trees]
  end

  def part2
    [[1, 1], [3, 1], [5, 1], [7, 1], [1, 2]]
      .map { traverse(_1)[:trees] }
      .inject(:*)
  end

  private

  def max_x
    terrain[0].length
  end

  def tree?(value)
    value == '#'
  end
end

solver = TobogganTrajectory.new
puts "PART I: #{ solver.part1 }"
puts "PART II: #{ solver.part2 }"
