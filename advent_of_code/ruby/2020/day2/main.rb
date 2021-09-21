# frozen_string_literal: true

def password_info_list
  File.open('./data.txt', 'r').readlines
end

def part_one_valid?(password, policy_char, range_start, range_end)
  policy_char_count_in_password = password.count(policy_char)
  policy_char_count_in_password >= range_start && policy_char_count_in_password <= range_end
end

def part_two_valid?(password, policy_char, first_position, second_position)
  [password[first_position.pred] == policy_char, password[second_position.pred] == policy_char].uniq.length > 1
end

def count_valid_passwords(password_policy)
  valid_passwords = 0
  password_info_list.each do |password_info|
    policy, password = password_info.split(':').map(&:strip)
    policy_char_range, policy_char = policy.split(' ')
    policy_char_range_start, policy_char_range_end = policy_char_range.split('-').map(&:to_i)
    valid_passwords += 1 if password_policy.call(password, policy_char, policy_char_range_start, policy_char_range_end)
  end
  valid_passwords
end

def part1
  count_valid_passwords(self.method(:part_one_valid?))
end

def part2
  count_valid_passwords(self.method(:part_two_valid?))
end

puts "part1 solution: #{part1}"
puts "part2 solution: #{part2}"
