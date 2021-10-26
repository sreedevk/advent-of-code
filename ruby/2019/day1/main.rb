# frozen_string_literal: true

def data
  File.open('data.txt', 'r').readlines.map(&:to_i)
end

def part1
  data.map do |rec_mass|
    (rec_mass / 3).floor - 2
  end.sum
end

def calculate_fuel_requirement(mass)
  fuel_mass = [(mass / 3).floor - 2, 0].max
  fuel_mass += calculate_fuel_requirement(fuel_mass) if fuel_mass > 0
  return fuel_mass
end

def part2
  data.map do |rec_mass|
    calculate_fuel_requirement(rec_mass)
  end.sum
end

puts "part1: #{part1}"
puts "part2: #{part2}"
