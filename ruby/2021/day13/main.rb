require 'set'
require 'matrix'

class TransparentOrigami
  def part1
    fold(dotspec, foldspec[0]).size
  end

  def part2
    dotmatrix = foldspec.reduce(dotspec) { |acc, line| fold(acc, line) }.to_set
    Matrix.build(*Matrix[*dotmatrix].column_vectors.map(&:max).map(&:next)) { dotmatrix.member?([_1, _2]) ? '#' : ' ' }
      .transpose
      .to_a
      .map(&:join)
  end

  def fold(dots, line)
    dots.reduce(Set[]) do |acc, (x, y)|
      acc.add(
        [
          (line[0].zero? ? x : line[0] - (line[0] - x).abs),
          (line[1].zero? ? y : line[1] - (line[1] - y).abs)
        ]
      )
    end
  end

  def dotspec
    @dotspec ||= data[0].split("\n").map { _1.split(",").map(&:strip).map(&:to_i) }
  end

  def foldspec
    @foldspec ||= data[1].split("\n").map { _1.split(" ").last.split("=") }.map do |spec|
      spec[0] == 'x' ? [spec[1].to_i, 0] : [0, spec[1].to_i]
    end
  end

  def data
    @data ||= ARGF.read.split("\n\n")
  end
end

solver = TransparentOrigami.new
pp solver.part1
puts solver.part2
