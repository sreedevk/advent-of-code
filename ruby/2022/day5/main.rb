# frozen_string_literal: true

# Day 5 2022
class SupplyStacks
  def initialize(data)
    @data = data.split("\n\n")
  end

  def solve1
    parse_instructions(@data[1])
      .reduce(parse_stacks(@data[0])) { |stx, inst| process_instruction(inst, stx) }
      .map(&:last)
      .join
  end

  private

  def process_instruction(instruction, stack)
    stack.tap do |stk|
      stk[instruction[:to] - 1]
        .push(*stk[instruction[:from] - 1].pop(instruction[:count]).reverse)
    end
  end

  def parse_instructions(instructions)
    instructions
      .lines
      .map { |line| line.match(/move\s(?<count>\d+)\sfrom\s(?<from>\d+)\sto\s(?<to>\d+)/) }
      .map { |line| { count: line[:count].to_i, from: line[:from].to_i, to: line[:to].to_i } }
  end

  def parse_stacks(stacks)
    stacks
      .lines
      .map { |line| line.chars.each_slice(4).map(&:join).map(&:strip) }
      .slice(0..-2)
      .transpose
      .map(&:reverse)
      .map { |stack| stack.reject(&:empty?).map { _1.tr('[]', '') } }
  end
end

solver = SupplyStacks.new(ARGF.read)
pp "PART 1: #{solver.solve1}"
