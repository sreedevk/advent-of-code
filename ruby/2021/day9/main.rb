require 'set'

class SmokeBasin
  def part1
    lowpoints.map(&:next).sum
  end

  def part2
    lowpoint_indices.inject(Set[]) { |basins, lowpoint_index| basins.add(scan_recurse(lowpoint_index, Set[lowpoint_index]).size) }
      .max(3)
      .inject(&:*)
  end

  def scan_recurse(lowpoint_index, basin_nodes)
    scannable_neighboring_indices = neighboring_indices(*lowpoint_index).reject do |node|
      basin_nodes.member?(node) || basin_end?(terrain.dig(*node.reverse))
    end

    return basin_nodes if scannable_neighboring_indices.none?

    scannable_neighboring_indices.reduce(Set[]) { |nodes, lpindx| nodes.merge(scan_recurse(lpindx, basin_nodes.add(lpindx))) }
  end

  def basin_end?(basin_height)
    basin_height > 8
  end

  def lowpoints
    @lowpoints ||= lowpoint_indices.map { terrain.dig(*_1.reverse) }
  end

  def lowpoint_indices
    @lowpoint_indices ||= terrain.map.with_index.reduce([]) do |rind, (row, y)|
      rind + row.filter_map.with_index { |point, x| x if point < neighbors(x, y).min }.product([y])
    end
  end

  def neighbors(x, y)
    neighboring_indices(x, y).map { terrain.dig(*_1.reverse) }
  end

  def neighboring_indices(x, y)
    [[x, y - 1], [x, y + 1], [x - 1, y], [x + 1, y]].filter { index_within_range?(*_1) }
  end

  def terrain
    @terrain ||= ARGF.readlines.map { _1.strip.split('').map(&:to_i) }
  end

  def terrain_neighbor_index_map
    @terrain_neighbor_index_map ||= [*0..terrain_xmax].product([*0..terrain_ymax]).inject({}) do |tmap, (x, y)|
      tmap.merge([x, y] => neighboring_indices(x, y))
    end
  end

  def terrain_xmax
    @terrain_xmax ||= terrain[0].length.pred
  end

  def terrain_ymax
    @terrain_ymax ||= terrain.length.pred
  end

  def index_within_range?(x, y)
    x >= 0 && y >= 0 && x <= terrain_xmax && y <= terrain_ymax
  end
end

solver = SmokeBasin.new
pp solver.part1
pp solver.part2
