require 'pry'

OFFSET = 25

def data
  File.open('./data.txt', 'r').readlines.map(&:to_i)
  # File.open('./example.txt', 'r').readlines.map(&:to_i)
end

error_found   = false
current_index = OFFSET.next

def error_check(set, sum)
  sum_set = []
  set.map do |addent_1|
    set.map do |addent_2|
      sum_set = [addent_1, addent_2] if addent_1 + addent_2 == sum
    end
  end
  [sum_set.empty?, sum_set]
end

errored_number = 0

until error_found
  calc_set = data[(current_index-OFFSET)..current_index.pred]
  current_value = data[current_index]
  error_found, _ = error_check(calc_set, current_value)
  if error_found
    errored_number = current_value
    puts "ERROR FOUND: #{errored_number} does not have a sum set in #{calc_set}"
    break
  end
  current_index += 1
end

def find_weakness(c_slice, required_sum)
  c_slice.sum == required_sum
end

range_start_size = 1
weakness_found = false
sub_data = data[0..(data.index(errored_number)).pred]
until weakness_found
  sub_data.each_with_index do |current_el, index|
    contiguous_slice = sub_data[[index-range_start_size, 0].max..index]
    weakness_found = find_weakness(contiguous_slice, errored_number)
    if weakness_found
      puts "WEAKNESS FOUND: #{weakness_found}; MIN: #{contiguous_slice.min}; MAX: #{contiguous_slice.max}"
      puts "XMAS VULN: #{contiguous_slice.min + contiguous_slice.max}"
      break
    end
  end
  range_start_size += 1
  break if weakness_found || range_start_size >= sub_data.size
end

