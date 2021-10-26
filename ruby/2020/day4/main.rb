required_fields = %w(byr iyr eyr hgt hcl ecl pid) # cid is optional

raw_passport_data = File.open('./data.txt', 'r').read
processed_passports = raw_passport_data.split("\n\n")

processed_passports.map! do |processed_passport_data|
  passport_data_hash = {}
  processed_passport_data.gsub("\n", ' ').split(' ').map do |pp_field|
    key, value = pp_field.split(':')
    passport_data_hash[key] = value
  end
  passport_data_hash
end

valid_passports_1 = processed_passports.select do |passport|
  required_fields.all? do |req_field|
    passport.key?(req_field)
  end
end

height_rules = {'cm' => (150..193), 'in' => (59..76)}
valid_passports_2 = valid_passports_1.select do |passport|
  height_unit = passport['hgt'].to_s.match(/(cm|in)/).to_s
  (1920..2002).include?(passport['byr'].to_i) &&
    (2010..2020).include?(passport['iyr'].to_i) &&
    (2020..2030).include?(passport['eyr'].to_i) &&
    !height_unit.nil? && !height_rules[height_unit].nil? &&
    height_rules[height_unit].include?(passport['hgt'].to_i) &&
    ['amb', 'blu', 'brn', 'gry', 'grn', 'hzl', 'oth'].include?(passport['ecl']) &&
    passport['pid'].to_s.match(/^[0-9]{9}$/) &&
    passport['hcl'].to_s.match(/^#[0-9a-f]{6}$/)
end

puts "valid_passports(part1): #{valid_passports_1.count}"
puts "valid_passports(part2): #{valid_passports_2.count}"
