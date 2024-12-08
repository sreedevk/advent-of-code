# frozen_string_literal: true

require_relative './src/calorie_counting'
require_relative './src/rock_paper_scissors'
require_relative './src/rucksack_reorganization'
require_relative './src/camp_cleanup'
require_relative './src/supply_stacks'
require_relative './src/tuning_trouble'
require_relative './src/no_space_left_on_device'
require_relative './src/treetop_tree_house'

def main(day, input)
  case day
  when '1'
    puts 'Advent of Code Day 01'
    puts "Part A: #{CalorieCounting.new(input).solve1}"
    puts "Part B: #{CalorieCounting.new(input).solve2}"
  when '2'
    puts 'Advent of Code Day 02'
    puts "Part A: #{RockPaperScissors.new(input).solve1}"
    puts "Part B: #{RockPaperScissors.new(input).solve2}"
  when '3'
    puts 'Advent of Code Day 03'
    puts "Part A: #{RucksackReorganization.new(input).solve1}"
    puts "Part B: #{RucksackReorganization.new(input).solve2}"
  when '4'
    puts 'Advent of Code Day 04'
    puts "Part A: #{CampCleanup.new(input).solve1}"
    puts "Part B: #{CampCleanup.new(input).solve2}"
  when '5'
    puts 'Advent of Code Day 05'
    puts "Part A: #{SupplyStacks.new(input).solve1}"
    puts "Part B: #{SupplyStacks.new(input).solve2}"
  when '6'
    puts 'Advent of Code Day 06'
    puts "Part A: #{TuningTrouble.new(input).solve1}"
    puts "Part B: #{TuningTrouble.new(input).solve2}"
  when '7'
    puts 'Advent of Code Day 07'
    solver = NoSpaceLeftOnDevice.new(input)
    puts "Part A: #{solver.solve1}"
    puts "Part B: #{solver.solve2}"
  when '8'
    puts 'Advent of Code Day 08'
    solver = TreetopTreeHouse.new(input)
    puts "Part A: #{solver.solve1}"
    puts "Part B: #{solver.solve2}"
  end
end

main ARGV[0], File.read(ARGV[1])
