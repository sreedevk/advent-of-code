class TheTreacheryofWhales
  def data
    @data ||= ARGF.read.split(",").map(&:strip).map(&:to_i)
  end

  def part1
    (1..data.max).map { |tp| data.sum { |cp| (cp - tp).abs }}.min
  end

  def part2
    (1..data.max).map { |tp| data.sum { |cp| (1..(cp - tp).abs).sum }}.min
  end
end

solver = TheTreacheryofWhales.new
pp solver.part1
pp solver.part2
