require 'matrix'
require 'pry'

class Board
  attr_accessor :grid, :marked

  def initialize(grid)
    @marked, @grid = [], Matrix[*grid]
  end

  def mark(num)
    if has_number?(num)
      @grid.find { _1[0] == num }[1] = true 
      @marked << num
    end
  end

  def has_number?(num)
    !@grid.find { _1[0] == num }.nil?
  end

  def won?
    @grid.row_vectors.any? {|row| row.all? {|el| el[1] } } || 
    @grid.column_vectors.any? {|col| col.all? {|el| el[1] } }
  end

  def solve
    @grid.find_all { !_1[1] }.map(&:first).sum * @marked[-1]
  end
end

class GiantSquid
  def data
    @data ||= ARGF.read.split("\n\n")
  end

  def parse_data(raw_input)
    raw_inputs, raw_boards = raw_input.partition.with_index { _2 == 0 }
    [parse_inputs(raw_inputs), parse_boards(raw_boards)]
  end

  def parse_inputs(raw_inputs)
    raw_inputs.map { _1.split(?,).map(&:to_i) }.flatten
  end

  def parse_boards(raw_boards)
    raw_boards.map do |board| 
        Board.new(
          board.split("\n")
            .map { _1.gsub(/\s+/, ' ').split(' ').map(&:to_i) }
            .reject(&:empty?) 
            .map { _1.map {|num| [num, false] } }
        )
      end
  end

  def part1
    p1nums, p1boards = parse_data(data)

    p1nums.each do |num|
      p1boards.each { |board| board.mark(num) }
      break if p1boards.any? { _1.won? }
    end

    winning_board = p1boards.find(&:won?)&.solve
  end

  def part2
    p2nums, p2boards = parse_data(data)
    emulate(p2boards, p2nums)[-1]&.solve
  end

  def emulate(b, i, w = [])
    return w if b.empty? || i.empty?

    next_call = i.shift
    b.each { |board| board.mark(next_call) }
    w += b.select(&:won?)
    emulate(b.reject(&:won?), i, w)
  end
end

solver = GiantSquid.new
pp solver.part1
pp solver.part2
