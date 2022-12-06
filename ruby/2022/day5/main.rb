# frozen_string_literal: true

# Day 5 2022
class SupplyStacks
  def initialize(data)
    @data = data.split("\n\n")
  end

  def solve1
    parse_instructions(@data[1])
      .reduce(parse_stacks(@data[0]), &method(:process_instruction_9000))
      .map(&:last)
      .join
  end

  def solve2
    parse_instructions(@data[1])
      .reduce(parse_stacks(@data[0]), &method(:process_instruction_9001))
      .map(&:last)
      .join
  end

  private

  def process_instruction_9000(stack, instruction)
    stack.tap do |stk|
      stk[instruction[:to]]
        .push(*stk[instruction[:from]].pop(instruction[:count]).reverse)
    end
  end

  def process_instruction_9001(stack, instruction)
    stack.tap do |stk|
      stk[instruction[:to]]
        .push(*stk[instruction[:from]].pop(instruction[:count]))
    end
  end

  def parse_instructions(instructions)
    instructions
      .lines
      .map { |line| line.match(/move\s(?<count>\d+)\sfrom\s(?<from>\d+)\sto\s(?<to>\d+)/) }
      .map { |line| { count: line[:count].to_i, from: line[:from].to_i.pred, to: line[:to].to_i.pred } }
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
pp "PART 2: #{solver.solve2}"
