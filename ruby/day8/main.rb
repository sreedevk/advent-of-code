# frozen_string_literal: true

require 'pry'

# Solution
class TreetopTreeHouse
  attr_accessor :grid

  def initialize
    @grid = ARGF.readlines
                .map(&:strip)
                .map(&:chars)
  end

  def visible?(coordx, coordy)
    visible_from_right?(coordx, coordy) ||
      visible_from_left?(coordx, coordy) ||
      visible_from_top?(coordx, coordy) ||
      visible_from_bottom?(coordx, coordy)
  end

  def visible_from_right?(coordx, coordy)
    @grid[coordy][(coordx + 1)..]
      .compact
      .count { |ot| ot >= @grid[coordy][coordx] }
      .then { |ct| ct < 1 }
  end

  def visible_from_left?(coordx, coordy)
    @grid[coordy][0...coordx]
      .compact
      .count { |ot| ot >= @grid[coordy][coordx] }
      .then { |ct| ct < 1 }
  end

  def visible_from_top?(coordx, coordy)
    @grid[0...coordy]
      .map { |grow| grow[coordx] }
      .compact
      .count { |ot| ot >= @grid[coordy][coordx] }
      .then { |ct| ct < 1 }
  end

  def visible_from_bottom?(coordx, coordy)
    @grid[(coordy + 1)..]
      .map { |grow| grow[coordx] }
      .compact
      .count { |ot| ot >= @grid[coordy][coordx] }
      .then { |ct| ct < 1 }
  end

  def scenic_score(coordx, coordy)
    %i[top_scenic_score bottom_scenic_score left_scenic_score right_scenic_score]
      .map { |mname| method(mname).call(coordx, coordy) }
      .inject(&:*)
  end

  def right_scenic_score(coordx, coordy)
    trees_to_the_right = grid[coordy][(coordx + 1)..]
    visible_trees = trees_to_the_right.take_while { |ctree| ctree < grid[coordy][coordx] }
    trees_to_the_right.size.eql?(visible_trees.size) ? visible_trees.size : visible_trees.size + 1
  end

  def left_scenic_score(coordx, coordy)
    trees_to_the_left = grid[coordy][...coordx].reverse
    visible_trees = trees_to_the_left.take_while { |ctree| ctree < grid[coordy][coordx] }
    trees_to_the_left.size.eql?(visible_trees.size) ? visible_trees.size : visible_trees.size + 1
  end

  def top_scenic_score(coordx, coordy)
    trees_above = grid[...coordy].map { |cgrid| cgrid[coordx] }.reverse
    visible_trees = trees_above.take_while { |ctree| ctree < grid[coordy][coordx] }
    trees_above.size.eql?(visible_trees.size) ? visible_trees.size : visible_trees.size + 1
  end

  def bottom_scenic_score(coordx, coordy)
    trees_below = grid[(coordy + 1)..].map { |cgrid| cgrid[coordx] }
    visible_trees = trees_below.take_while { |ctree| ctree < grid[coordy][coordx] }
    trees_below.size.eql?(visible_trees.size) ? visible_trees.size : visible_trees.size + 1
  end

  def solve2
    (0..grid.size.pred)
      .map { |y| (0..grid.first.size.pred).map { |x| scenic_score(x, y) } }
      .flatten
      .max
  end

  def solve1
    (0..grid.size.pred).sum do |y|
      (0..grid.first.size.pred).count { |x| visible?(x, y) }
    end
  end
end

solver = TreetopTreeHouse.new
puts "PART I: #{solver.solve1}"
puts "PART II: #{solver.solve2}"
