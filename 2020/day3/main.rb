# frozen_string_literal: true

def geomap
  File.open('./data.txt', 'r').readlines.map(&:chars)
end

def traverse(slope, terrain, current_x, current_y, tree_count)
  slope[0].times do
    if current_x == 30
      (current_x = 0)
    else
      current_x += 1
    end
  end
  current_y += slope[1]
  tree_count += 1 if current_y < terrain.length && terrain.dig(current_y, current_x) == '#'
  [current_x, current_y, tree_count]
end

def part1
  slope = [3, 1]
  current_x, current_y, tree_count = 0, 0, 0
  terrain = geomap
  terrain.each do
    break if current_y >= terrain.length

    current_x, current_y, tree_count = traverse(slope, terrain, current_x, current_y, tree_count)
  end
  tree_count
end

def part2
  slopes = [[1, 1], [3, 1], [5, 1], [7, 1], [1, 2]]
  slopes.map do |slope|
    current_x, current_y, tree_count = 0, 0, 0
    terrain = geomap
    terrain.each do
      break if current_y >= terrain.length

      current_x, current_y, tree_count = traverse(slope, terrain, current_x, current_y, tree_count)
    end
    tree_count
  end.inject(:*)
end

puts "part1 solution: #{part1}"
puts "part2 solution: #{part2}"
