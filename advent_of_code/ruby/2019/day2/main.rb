require 'pry'

class Machine
  attr_accessor :program

  def initialize
    @halt                = false
    @instruction_pointer = 0
    @opcodes             = {
      1  => method(:add_var).to_proc,
      2  => method(:product_var).to_proc,
      99 => method(:halt).to_proc
    }
  end

  def load_program(filepath)
    @program_file_path = filepath
    @program_file = File.open(@program_file_path, 'r')
    @program = @program_file.read.split(',').map(&:strip).map(&:to_i)
    @program_file.close
  end

  def reset
    @instruction_pointer = 0
    @halt = false
    load_program(@program_file_path)
  end

  def run
    until @halt
      operation = @opcodes.fetch(@program[@instruction_pointer], nil).call
      terminate_program if operation.nil?
    end
  end

  private

  def terminate_program
    @halt = true
    raise 'Unknown Opcode'
  end

  def add_var
    @program[@program[@instruction_pointer + 3]] = [
      @program[@program[@instruction_pointer + 1]],
      @program[@program[@instruction_pointer + 2]]
    ].inject(:+)
    @instruction_pointer += 4
  end

  def product_var
    @program[@program[@instruction_pointer + 3]] = [
      @program[@program[@instruction_pointer + 1]],
      @program[@program[@instruction_pointer + 2]]
    ].inject(:*)
    @instruction_pointer += 4
  end

  def halt
    @halt = true
  end
end

machine = Machine.new
machine.load_program('./data.txt')
machine.program[1] = 12
machine.program[2] = 2
machine.run

puts "(part1) position[0] = #{machine.program[0]}"

machine.reset

part2_target = 19_690_720
found = false
target_noun, target_verb = nil, nil

(0..99).map do |noun|
  (0..99).map do |verb|
    machine.program[1] = noun
    machine.program[2] = verb
    machine.run
    if machine.program[0] == part2_target
      found = true
      target_noun, target_verb = noun, verb
      break
    end
    machine.reset
  end
  break if found
end

puts "(part2) noun: #{target_noun}; verb: #{target_verb}; 100 * noun + verb: #{100 * target_noun + target_verb}"
