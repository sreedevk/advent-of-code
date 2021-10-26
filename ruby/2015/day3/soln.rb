# frozen_string_literal: true

require 'pry'

class Distributor
  attr_accessor :location, :visited_locations

  def initialize
    @location = [0, 0]
    @visited_locations = {}
  end

  def add_location_to_hash_table(coordinates)
    @visited_locations[coordinates[0]] = (@visited_locations[coordinates[0]].to_a + [coordinates[1]]).uniq
  end

  def process_instruction(delta_x, delta_y)
    @location[0] += delta_x
    @location[1] += delta_y
    add_location_to_hash_table(@location)
  end

  def visited_locations_array
    @visited_locations.map { |x_coord, ys| ys.map { |ycoords| [x_coord, ycoords] } }
  end
end

class PerfectlySphericalHousesInAVacuum
  attr_accessor :distributors

  DIRECTIONS = {
    '^' => [1, 0],
    'v' => [-1, 0],
    '>' => [0, 1],
    '<' => [0, -1]
  }.freeze

  def initialize(distributor_count = 2)
    @instructions        = File.open('./build/data.txt', 'r').read.strip.split('')
    @instruction_pointer = 0
    @distributors        = (0..distributor_count.pred).map { Distributor.new }
    @distributors_enum   = @distributors.cycle
  end

  def solve
    @instructions.map do |instruction|
      process_instruction(instruction)
    end

    @distributors.map(&:visited_locations_array).flatten(2).uniq
  end

  def process_instruction(instruction)
    @distributors_enum.next.process_instruction(*DIRECTIONS[instruction])
  end
end

puts PerfectlySphericalHousesInAVacuum.new.solve.count
