# class Trebuchet
#   attr_accessor :input
#   DIGITS = %w[zero one two three four five six seven eight nine]
#
#   def initialize(input)
#     @input = input
#   end
#
#   def process_line(line)
#     line.strip.gsub(/(#{DIGITS.join("|")})/) do |capture|
#       case capture
#       when "zero" then "0"
#       when "one" then "1"
#       when "two" then "2"
#       when "three" then "3"
#       when "four" then "4"
#       when "five" then "5"
#       when "six" then "6"
#       when "seven" then "7"
#       when "eight" then "8"
#       when "nine" then "9"
#       else
#         raise! "Unknown digit: #{capture}"
#       end
#     end
#   end
#
#   def calibration_value(line)
#     line
#       .chars
#       .select { |char| ('0'..'9').include?(char) }
#       .map(&:to_i)
#       .then { |chars| (chars[0] * 10) + chars[-1] }
#   end
#
#   def solve
#     @input.lines.lazy
#       .map { |line| process_line(line) }
#       .map { |line| calibration_value(line) }
#       .sum
#   end
# end

data = ARGF.read
# p "SREEDEV: #{Trebuchet.new(data).solve}"

WORDS = {
  'one' => 1,
  'two' => 2,
  'three' => 3,
  'four' => 4,
  'five' => 5,
  'six' => 6,
  'seven' => 7,
  'eight' => 8,
  'nine' => 9
}
WORDS_RE = "#{WORDS.keys.join('|')}"

def parse_digit(d)
  WORDS[d] || d.to_i
end

puts data.each_line.reduce(0) { |sum, line|
  line =~ /^.*?(\d|#{WORDS_RE})/
  first_digit = $1
  line =~ /.*(\d|#{WORDS_RE}).*$/
  last_digit = $1
  sum + "#{parse_digit first_digit}#{parse_digit last_digit}".to_i
}
