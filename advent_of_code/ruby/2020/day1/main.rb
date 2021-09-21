# frozen_string_literal: true

def data
  File.open('./data.txt', 'r').readlines.map(&:strip).map(&:to_i)
end

REQUIRED_SUM = 2020

def numbers_less_than_required_sum
  data.select { |number| number < REQUIRED_SUM }
end

def part1
  sum_pair =  []
  numbers_less_than_required_sum.map do |input_one|
    numbers_less_than_required_sum.map do |input_two|
      sum_pair = [input_one, input_two] if input_one + input_two == REQUIRED_SUM
    end
  end
  sum_pair.inject(:*)
end

def part2
  sum_triplet = []
  numbers_less_than_required_sum.map do |input_one|
    numbers_less_than_required_sum.map do |input_two|
      numbers_less_than_required_sum.map do |input_three|
        sum_triplet = [input_one, input_two, input_three] if input_one + input_two + input_three == REQUIRED_SUM
      end
    end
  end
  sum_triplet.inject(:*)
end

puts "part1 solution: #{part1}"
puts "part2 solution: #{part2}"
