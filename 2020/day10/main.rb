class Adapter
  attr_accessor :joltage

  def initialize(joltage)
    @joltage = joltage
  end

  def supports_input?(input_joltage)
    input_range.cover?(input_joltage)
  end

  def input_range
    (@joltage-3)..(@joltage-1)
  end
end

class AdapterArray
  attr_accessor :jolt_differences, :adapters, :device_rating, :adapters_specs

  def initialize(adapters_specs: File.open('./data.txt', 'r').readlines.map(&:to_i), adapters: [])
    @adapters_specs        = adapters_specs.uniq
    @adapters              = adapters.uniq(&:joltage).sort_by(&:joltage)
    load_adapters
    @jolt_differences      = { 1 => 0, 3 => 1, 2 => 0 }
    @device_rating         = (self.max.joltage + 3)
  end

  def [](index)
    @adapters[index]
  end

  # utilize maximum number of adapters
  def arrange_adapters(usage=0, current_output_rating=0)
    @adapters.map do |adapter|
      selected_adapter = AdapterArray.new(adapters: @adapters.select do |f_adapter|
        f_adapter.supports_input?(current_output_rating)
      end).send(:[], usage)
      @jolt_differences[(selected_adapter.joltage - current_output_rating)] += 1
      current_output_rating = selected_adapter.joltage
      selected_adapter
    end
  end

  def arrange_combinations(input_joltage_rating)
    @combinations = {}
    eval_combination(0)
    @combinations[input_joltage_rating]
  end

  def eval_combination(joltage_rating)
    return 1 if joltage_rating == max.joltage

    unless @combinations.key?(joltage_rating)
      sub_combinations = 3.times.map do |c_index|
        eval_combination(joltage_rating+c_index.next) if include?(joltage_rating+c_index.next)
      end
      @combinations[joltage_rating] = sub_combinations.compact.sum
    end
    @combinations[joltage_rating]
  end

  def include?(joltage_rating)
    @adapters.find do |adapter|
      adapter.joltage == joltage_rating
    end
  end

  def load_adapters
    if @adapters.empty?
      @adapters_specs.sort.each do |adapter_rating|
        @adapters << Adapter.new(adapter_rating)
      end
    end
  end

  def max
    @adapters.last
  end

  def min
    @adapters.first
  end
end

adapter_array = AdapterArray.new
adapter_array.arrange_adapters

puts "part1: #{adapter_array.jolt_differences[1] * adapter_array.jolt_differences[3]}"

adapter_array = AdapterArray.new


puts "part2: #{adapter_array.arrange_combinations(0)}"
