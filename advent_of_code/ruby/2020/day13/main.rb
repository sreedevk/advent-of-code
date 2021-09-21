# frozen_string_literal: true

require './chinese_remainder.rb'

data            = ARGF.readlines
leavetime       = data[0].to_i
buses           = data[1].split(',').map(&:strip)
running_buses   = buses.map(&:to_i).reject(&:zero?)

# part 1 - 295

c_lt = leavetime
lcm = ->  { running_buses.map { |bus_id| c_lt.divmod(bus_id) } }
c_lt += 1 while lcm.call.map(&:last).none?(&:zero?)

next_bus  = running_buses.find { |bus_id| c_lt.modulo(bus_id).zero? }
wait_time = c_lt - leavetime

puts "next lt: #{c_lt}; bus_id: #{next_bus}; wait_time: #{wait_time}; part1: #{wait_time * next_bus}"

# part 2

offsets = []

buses.map.with_index do |bus_id, i|
  offsets << i * -1 unless bus_id == 'x'
end

p ChineseRemainder.solve(running_buses, offsets)

__END__

t such that:
  t % 7  == 0
  t % 13 == 13 - 1
  t % 59 == 59 - 4
  t % 31 == 31 - 6
  t % 19 == 19 - 7
