# frozen_string_literal: true

class DockingData
  INVALID_BIN = 'X'.freeze
  BITSIZE     = 36

  def data
    @data ||= ARGF.readlines
  end

  def initialize
    reset
  end

  def memory_sum
    @mem.values.sum
  end

  def reset
    @mem = {}
  end

  def part1
    data.each do |instr|
      cmd, arg = instr.strip.split(' = ')
      eval <<-RUBY, __FILE__, __LINE__ + 1
        @#{cmd} = #{cmd.match('mask') ? "'#{arg}'" : "process_data_bits(#{arg})"}
      RUBY
    end
    memory_sum
  end

  def part2
    data.each do |instr|
      cmd, arg = instr.strip.split(' = ')
      eval("@#{cmd} = '#{arg}'") && next if cmd.match(/mask/)

      store_at_varied_addresses(cmd.match(/\d+/).to_s.to_i, arg)
    end
    memory_sum
  end

  def store_at_varied_addresses(addr, ddata)
    floating_addr = @mask.chars.zip(addr.to_s(2).rjust(BITSIZE, '0').chars).map do |mbit, abit|
      mbit == '0' ? abit : mbit
    end.join('')

    fbit_permutations(@mask.count(INVALID_BIN)).map do |bit_arrangement|
      address = floating_addr.gsub(INVALID_BIN, '%d')
      @mem[(address % bit_arrangement.chars).to_i(2)] = ddata.to_i
    end
  end

  def fbit_permutations(digits)
    (2**digits).times.map do |int|
      int.to_s(2).rjust(digits, '0')
    end
  end

  def process_data_bits(decimal_data)
    @mask.chars.zip(decimal_data.to_s(2).rjust(BITSIZE, '0').chars).map do |mask_bit, val_bit|
      mask_bit == INVALID_BIN ? val_bit : mask_bit
    end.join('').to_i(2)
  end
end

dd = DockingData.new
puts "part1: memory sum = #{dd.part1}"

dd.reset
puts "part2: memory sum = #{dd.part2}"
