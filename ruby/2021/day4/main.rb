require 'matrix'

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
    @grid.row_vectors.any? { _1.all?(&:last) } || @grid.column_vectors.any? { _1.all?(&:last) }
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
    emulatep1(*parse_data(data))&.solve
  end

  def emulatep1(nums, boards)
    return boards.find(&:won?) if boards.any?(&:won?) || nums.empty?

    boards.each { |board| board.mark(nums[0]) }
    emulatep1(nums.tap(&:shift), boards)
  end

  def part2
    emulatep2(*parse_data(data))[-1]&.solve
  end

  def emulatep2(nums, boards, wboards = [])
    return wboards if boards.empty? || nums.empty?

    boards.each { |board| board.mark(nums[0]) }
    emulatep2(nums.tap(&:shift), boards.reject(&:won?), wboards + boards.select(&:won?))
  end
end

solver = GiantSquid.new
pp solver.part1
pp solver.part2
