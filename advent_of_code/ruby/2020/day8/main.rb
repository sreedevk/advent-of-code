require 'pry'

$accumulator = 0
$stack_ptr = 0
$stack_ptr_history = []

def opcodes
  File.open('./data.txt', 'r').readlines
  # File.open('./example.txt', 'r').readlines
end

def parse_instructions(opcode_list)
  opcode_list.map do |iseq|
    inst, arg = iseq.split(' ')
    [inst, arg.to_i]
  end
end

def acc(iseq_arg)
  $accumulator += iseq_arg
  $stack_ptr_history << $stack_ptr
  $stack_ptr += 1
end

def jmp(iseq_arg)
  $stack_ptr_history << $stack_ptr
  $stack_ptr += iseq_arg
end

def nop(iseq_arg)
  $stack_ptr_history << $stack_ptr
  $stack_ptr += 1
end

def run(iseq)
  self.send(iseq[$stack_ptr][0].to_sym, iseq[$stack_ptr][1])
  return false if $stack_ptr_history.include?($stack_ptr)

  ($stack_ptr < iseq.length) ? run(iseq) : true
end

def reset_machine
  $accumulator = 0
  $stack_ptr = 0
  $stack_ptr_history = []
end

def alter_sector(seq, index)
  seq[index][0] = (seq[index][0] == 'jmp' ? 'nop' : 'jmp')
  seq
end

def part1
  reset_machine
  boot_seq = parse_instructions(opcodes)
  run(boot_seq)
  puts "last value of accumulator(part1): #{$accumulator}"
end

def part2
  boot_seq = parse_instructions(opcodes).freeze
  counter = 0
  terminated = false
  while(!terminated)
    break if !boot_seq[counter]

    cloned_seq = parse_instructions(opcodes)
    unless ['jmp', 'nop'].include?(cloned_seq[counter][0])
      counter += 1
      next
    end

    cloned_seq = alter_sector(cloned_seq, counter)
    reset_machine
    terminated = run(cloned_seq)
    puts "altered_sector: #{cloned_seq[counter]}; original_sector: #{boot_seq[counter]}; terminated? #{terminated}"
    break if terminated
    counter += 1
  end
  puts "last value of accumulator(part2): #{$accumulator}"
end

part1
part2
