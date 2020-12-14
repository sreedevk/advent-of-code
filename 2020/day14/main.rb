require 'pry'

class DockingData
  attr_accessor :mem, :mask

  def initialize
    @mem          = {}
    @mask         = ''
  end

  def data
    @data ||= ARGF.readlines
  end

  def memory_sum
    @mem.values.compact.sum
  end

  def reset
    @mem  = {}
    @mask = ''
  end

  def part1
    data.each do |instruction|
      command, arg = instruction.split('=').map(&:strip)
      if command.match(/mask/)
        @mask = arg
      else
        eval("@#{command} = process_bits_with_mask(#{arg})") 
      end
    end
  end

  def part2
    data.each do |instruction|
      command, arg = instruction.split('=').map(&:strip)
      if command.match(/mask/)
        @mask = arg
      else
        # addresses = decode_address(command.match(/\d+/).to_s.to_i)
        addresses = decode_addr(command.match(/\d+/).to_s.to_i)
        addresses.map {|addr| @mem[addr] = arg.to_i }
      end
    end
  end

  def floating_bit_combinations
    (2 ** @mask.count('X')).times.map do |fcomb|
      fcomb.to_s(2).rjust(@mask.count('X'), "0") 
    end
  end

  def decode_address(addr)
    masks = floating_bit_combinations.map do |bit_arrangement|
      dup_mask = @mask.dup.gsub('X', '%d')
      dup_mask % bit_arrangement.chars
    end

    bin_addr = addr.to_s(2).rjust(36, '0')

    masks.map do |cmask|
      cmask.chars.zip(bin_addr.chars).map do |mask_bit, val_bit|
        mask_bit == '1' ? '1' : val_bit
      end.join('').to_i(2)
    end.uniq
  end

  def decode_addr(addr)
    address = @mask.chars.zip(addr.to_s(2).rjust(36, '0').chars).map do |mbit, abit|
      mbit == 'X' || mbit == '1' ? mbit : abit
    end.join('')

    floating_bit_combinations.map do |fbit_arrangement|
      address = address.gsub('X', '%d')
      (address % fbit_arrangement.chars).to_i(2)
    end
  end

  def process_bits_with_mask(decimal)
    binary = decimal.to_s(2).rjust(36, "0")
    @mask.chars.zip(binary.chars).map.with_index do |compare_bits, index|
      mask_bit, val_bit = compare_bits
      mask_bit.downcase == 'x' ? val_bit : mask_bit
    end.join('').to_i(2)
  end
end

dd = DockingData.new
# dd.part1
# puts "part1: memory sum: #{dd.memory_sum}"

dd.reset

dd.part2
puts "part2: memory sum: #{dd.memory_sum}"
