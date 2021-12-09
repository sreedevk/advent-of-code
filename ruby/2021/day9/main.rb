class SmokeBasin
  def part1
    lowpoints.map(&:next).sum
  end

  def scan_low_points(mapdat)
    mapdat.map.with_index do |row, y|
      row.map.with_index do |point, x|
        [point, point < neighboring_indices(x, y).map { terrain.dig(*_1.reverse) }.compact.min ]
      end
    end
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
# pp solver.part2
