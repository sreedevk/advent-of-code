def raw_baggage_rules
  File.open('./data.txt', 'r').readlines
end

def parse_baggage_rules(raw_data)
  raw_data.inject({}) do |rules, baggage_rule|
    outerbag, holding_bags = baggage_rule.split('contain').map(&:strip)
    if !holding_bags.match('no other bags')
      holding_bags = holding_bags.split(',').map(&:strip)
      holding_bags = holding_bags.inject({}) do |mem, holding_bag_spec|
        holding_bag_count = holding_bag_spec.match(/\d/).to_s
        mem[holding_bag_spec.gsub(holding_bag_count, '')
          .strip
          .gsub(/[^a-zA-Z0-9\s]/, '')
          .gsub('bags', 'bag')] = holding_bag_count.to_i
        mem
      end
    else
      holding_bags = {}
    end
    rules[outerbag.gsub('bags', 'bag')] = holding_bags
    rules
  end
end

$baggage_rules = parse_baggage_rules(raw_baggage_rules)
$total_bags = []

def search(bag)
  holding_bags = $baggage_rules.select{ |baggage_name, contains| contains.key?(bag) }
  return [] if holding_bags.nil?
  $total_bags += holding_bags.keys
  holding_bags.each do |holding_bag|
    search(holding_bag[0])
  end
end

search('shiny gold bag')

$total_count = 0

def find_count(bag, multiplier=1)
  $baggage_rules[bag].map do |subbag, count|
    $total_count += (count * multiplier)
    find_count(subbag, (count * multiplier))
  end
end

puts "(part 1) number of bags that can evetually contain atleast one shiny gold bag: #{$total_bags.uniq.count}"

find_count('shiny gold bag')
puts "(part 2) shiny gold bag  can hold: #{$total_count} bags"
