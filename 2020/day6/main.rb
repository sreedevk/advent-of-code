data = File.open('./aoc6data.txt', 'r').read.split("\n\n").map{|group| group.strip.split("\n") }
# data = File.open('./aoc6sample.txt', 'r').read.split("\n\n").map{|group| group.strip.split("\n") }

group_totals_1 = data.map do |group|
  group.map do |person|
    person.chars
  end.flatten.uniq.count
end

group_totals_1.sum

group_totals_2 = data.map do |group|
  group.map do |person|
    person.chars.select{|question| group.all?{|group_person| group_person.chars.include?(question) } }
  end
end

group_totals_2.flatten.sum
group_totals_2.map{|x| x.flatten.uniq.count }.sum
