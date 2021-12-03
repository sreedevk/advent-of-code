require 'pry'

class HandheldHalting
  def data
    @data ||= ARGF.readlines
      .map { _1.split(" ") .map(&:strip) }
      .map { [_1.to_sym, Integer(_2)] }
  end

  def part1(state = initial_state, instructions = data.clone)
    if (state[:looped] = state[:ptr_history].include?(state[:ptr])) ||
      (state[:ptr] > instructions.length.pred)
      return state 
    end

    part1(self.send(*instructions[state[:ptr]], state))
  end

  def part2(state = initial_state)
    variable_instruction_locations = data
      .map
      .with_index
      .select { [:jmp, :nop].include?(_1[0][0]) }
      .map { _1[1] }

    variable_instruction_locations
      .map { |instr_index| [instr_index, part1(initial_state, switched_instructions(instr_index)) ] }
      .find { !_1[1][:looped] }
  end

  private

  def initial_state
    {ptr_history: [], ptr: 0, accumulator: 0, looped: false}
  end

  def switched_instructions(index_to_switch_at)
    instructions = data.clone
    instructions[index_to_switch_at] = [
      [:nop, :jmp].find { instructions[index_to_switch_at][0] != _1 },
      instructions[index_to_switch_at][1]
    ]
    instructions
  end

  def jmp(arg, state)
    {
      ptr_history: state[:ptr_history] + [state[:ptr]],
      ptr: state[:ptr] + arg,
      accumulator: state[:accumulator]
    }
  end

  def nop(arg, state)
    {
      ptr_history: state[:ptr_history] + [state[:ptr]],
      ptr: state[:ptr] + 1,
      accumulator: state[:accumulator]
    }
  end

  def acc(arg, state)
    {
      ptr_history: state[:ptr_history] + [state[:ptr]],
      ptr: state[:ptr] + 1,
      accumulator: state[:accumulator] + arg
    }
  end
end

solver = HandheldHalting.new
puts "part I: #{solver.part1[:accumulator]}"
puts "part II: #{solver.part2[:accumulator]}"
