# frozen_string_literal: true
require 'pry'

def data
  $data ||= File.open('./data.txt', 'r').readlines.map(&:strip).map(&:chars)
  $rows ||= $data.length
  $columns ||= $data[0].length
  return $data
end

def sample_data
  $sample_data ||= File.open('./example.txt', 'r').readlines.map(&:strip).map(&:chars)
  $rows ||= $sample_data.length
  $columns ||= $sample_data[0].length
  return $sample_data
end

class Seat
  OCCUPIED = '#'
  FREE     = 'L'

  LEFT     = -> (row, column) { [row, column - 1] }
  RIGHT    = -> (row, column) { [row, column + 1] }
  FRONT    = -> (row, column) { [row - 1, column] }
  BACK     = -> (row, column) { [row + 1, column] }

  attr_accessor :state, :position, :parent_array

  def initialize(state, position, parent_array)
    @state = state if [OCCUPIED, FREE].include?(state)
    @position = position
    @parent_array = parent_array
  end

  def free?
    state == FREE
  end

  def occupied?
    state == OCCUPIED
  end

  def adj_seats
    row, column = @position
    mem = {}
    [:left, :right, :front, :back, :left_back, :right_back, :left_front, :right_front].each do |pos|
      next_coor = calc_next(row, column, pos)
      mem[pos] = next_coor.nil? ? nil : @parent_array.seats.dig(*next_coor)
    end
    mem.select{|position_key, position_value| position_value.is_a?(Seat) }
  end

  def visible_adj_seats
    mem = {}
    [:left, :right, :front, :back, :left_back, :right_back, :left_front, :right_front].each do |pos|
      nxt_seat = first_visible_seat(pos)
      mem[pos] = nxt_seat if !nxt_seat.nil?
    end
    mem
  end

  def first_visible_seat(direction)
    change = nil
    case direction
    when :left
      change = [0, -1]
    when :right
      change = [0, 1]
    when :front
      change = [-1, 0]
    when :back
      change = [1, 0]
    when :right_front
      change = [-1, 1]
    when :right_back
      change = [1, 1]
    when :left_front
      change = [-1, -1]
    when :left_back
      change = [1, -1]
    end
    current_row, current_col = @position
    current_visible = nil
    loop do
      current_row += change[0]
      current_col += change[1]
      break if [current_row, current_col].any?(&:negative?) ||
        current_row >= $rows ||
        current_col >= $columns

      tmp_visible_coor = @parent_array.seats.dig(current_row, current_col)
      if tmp_visible_coor.is_a?(Seat)
        current_visible = tmp_visible_coor
        break
      end
    end
    current_visible
  end

  def calc_next(row, column, position)
    nextp = nil
    case position
    when :left
      nextp = LEFT.call(row, column)
    when :right
      nextp = RIGHT.call(row, column)
    when :front
      nextp = FRONT.call(row, column)
    when :back
      nextp = BACK.call(row, column)
    when :right_front
      nextp = RIGHT.call(*FRONT.call(row, column))
    when :right_back
      nextp = RIGHT.call(*BACK.call(row, column))
    when :left_front
      nextp = LEFT.call(*FRONT.call(row, column))
    when :left_back
      nextp = LEFT.call(*BACK.call(row, column))
    end
    nextp if !nextp.any?(&:negative?) && (nextp[0] < $rows) && (nextp[1] < $columns)
  end
end

class SeatingArray
  FLOOR = '.'
  attr_accessor :seats

  def initialize(data=[])
    @seats = data.each_with_index.map do |arrangement_row, row_index|
      arrangement_row.each_with_index.map do |state, position_index|
        state == FLOOR ? FLOOR : Seat.new(state, [row_index, position_index], self)
      end
    end
  end

  def free_seats
    @seats.select do |seat|
      seat.state == Seat::FREE
    end.map {|free_seat| {position: free_seat.position, adj_seats: free_seat.adj_seats}}
  end

  def adj_seats(*seat)
    seat = @seats.dig(seat[0], seat[1])
    seat.is_a?(Seat) ? seat.adj_seats : {}
  end

  def occupied_seats
    @seats.flatten.count do |seat|
      seat.is_a?(Seat) && seat.state == Seat::OCCUPIED
    end
  end

  def inspect
    @seats.map do |row|
      row.map do |col|
        col.is_a?(String) ? col : col.state
      end.join(' ')
    end
  end
end

previous_set = SeatingArray.new(data)

loop do
  current_set = SeatingArray.new
  current_set.seats = previous_set.seats.each_with_index.map do |row, rindex|
    row.each_with_index.map do |seat, cindex|
      if seat == SeatingArray::FLOOR
        SeatingArray::FLOOR
      elsif seat.free? && !seat.adj_seats.values.any?(&:occupied?)
        Seat.new(Seat::OCCUPIED, [rindex, cindex], current_set)
      elsif seat.occupied? && seat.adj_seats.values.count(&:occupied?) >= 4
        Seat.new(Seat::FREE, [rindex, cindex], current_set)
      else
        Seat.new(seat.state, [rindex, cindex], current_set)
      end
    end

  end

  # FORMATTING 
  # space = "\t\t\t"
  # print_format = []
  # print_format << (["previous_set", "current_set"].join(space))

  # previous_set.inspect.each_with_index.map do |line, index|
  #   print_format << [line, current_set.inspect[index]].join(space)
  # end

  # print_format << ["prev: #{previous_set.occupied_seats}", "current: #{current_set.occupied_seats}"].join(space)
  # print_format << "\n"

  # puts print_format

  # FORMATTING END

  if current_set.occupied_seats == previous_set.occupied_seats
    puts "part1: #{current_set.occupied_seats}"
    break
  else
    previous_set = current_set
  end
end







previous_set = SeatingArray.new(data)
current_set  = nil

loop do
  current_set = SeatingArray.new
  current_set.seats = previous_set.seats.each_with_index.map do |row, rindex|
    row.each_with_index.map do |seat, cindex|
      if seat == SeatingArray::FLOOR
        SeatingArray::FLOOR
      elsif seat.free? && !seat.visible_adj_seats.values.any?(&:occupied?)
        Seat.new(Seat::OCCUPIED, [rindex, cindex], current_set)
      elsif seat.occupied? && seat.visible_adj_seats.values.count(&:occupied?) >= 5
        Seat.new(Seat::FREE, [rindex, cindex], current_set)
      else
        Seat.new(seat.state, [rindex, cindex], current_set)
      end
    end

  end

  # FORMATTING 
  space = "\t\t\t"
  print_format = []
  print_format << (["previous_set", "current_set"].join(space))

  previous_set.inspect.each_with_index.map do |line, index|
    print_format << [line, current_set.inspect[index]].join(space)
  end

  print_format << ["prev: #{previous_set.occupied_seats}", "current: #{current_set.occupied_seats}"].join(space)
  print_format << "\n"

  puts print_format

  # FORMATTING END

  if current_set.occupied_seats == previous_set.occupied_seats
    puts "part2: #{current_set.occupied_seats}"
    break
  else
    previous_set = current_set
  end
end


