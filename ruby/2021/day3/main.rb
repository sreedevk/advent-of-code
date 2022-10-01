require 'matrix'
require 'pry'

class BinaryDiagnostic
  def data
    @data ||= ARGF.readlines.map(&:strip).map(&:chars).map { _1.map(&:to_i) }
  end

  def part1
    data
      .transpose
      .map(&:reverse)
      .map { _1.tally.minmax_by(&:last).map(&:first) }
      .transpose
      .map { _1.join.to_i(2) }
      .inject(&:*)
  end

  def part2
    filter_oxygen(data).join.to_i(2) * filter_carbon(data).join.to_i(2)
  end

  def filter_oxygen(numbers, column_index = 0)
    mode_bit       = oxy_mode_bit_calc(Matrix[*numbers].column(column_index).to_a.tally.invert)
    filtered_layer = numbers.select { |number| number[column_index] == mode_bit }
    return filtered_layer[0] if filtered_layer.length < 2

    filter_oxygen(filtered_layer, column_index + 1)
  end

  def filter_carbon(numbers, column_index = 0)
    mode_bit = carbox_mode_bit_calc(Matrix[*numbers].column(column_index).to_a.tally.invert)
    filtered_layer = numbers.select { |number| number[column_index] == mode_bit }
    return filtered_layer[0] if filtered_layer.length < 2

    filter_carbon(filtered_layer, column_index + 1)
  end

  def carbox_mode_bit_calc(freq_dist)
    return 0 unless freq_dist.keys.uniq.length > 1

    freq_dist[freq_dist.keys.min]
  end

  def oxy_mode_bit_calc(freq_dist)
    return 1 unless freq_dist.keys.uniq.length > 1

    freq_dist[freq_dist.keys.max]
  end
end

solver = BinaryDiagnostic.new
puts "PART I: #{solver.part1.inspect}"
puts "PART II: #{solver.part2.inspect}"
