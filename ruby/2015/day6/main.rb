# frozen_string_literal: true

def execute(instruction, circuit)
  circuit.merge(
    instruction[1] => instruction[0]
      .scan(/[a-z]+/)
      .reduce(instruction[0]) { |acc, x| acc.gsub(x, circuit[x]) }
  )
end

def parse_instruction(instruction)
  instruction
    .gsub('AND', '&')
    .gsub('OR', '|')
    .gsub('LSHIFT', '<<')
    .gsub('RSHIFT', '>>')
    .gsub('NOT ', '~')
end

def parse
  ARGF
    .readlines
    .map { |x| parse_instruction(x.strip) }
    .map { |x| x.split(' -> ') }
    .reduce({}) { |circ, x| execute(x, circ) }
    .transform_values { |x| eval(x).to_s(2) }
end

p parse
