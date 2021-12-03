class PassportProcessing
  def data
    @data ||= ARGF
      .read
      .split("\n\n")
      .map { _1.gsub("\n", ' ').split(' ').inject({}){|store, keyval| store.merge(Hash[*keyval.split(?:)]) } }
  end

  def part1
    data.count { |passport| %w(byr iyr eyr hgt hcl ecl pid).all?(&passport.method(:key?)) }
  end

  def part2
    data
      .select { |passport| %w(byr iyr eyr hgt hcl ecl pid).all?(&passport.method(:key?)) }
      .count do |passport| 
        (1920..2002).cover?(passport['byr'].to_i) &&
        (2010..2020).cover?(passport['iyr'].to_i) &&
        (2020..2030).cover?(passport['eyr'].to_i) &&
        %w[amb blu brn gry grn hzl oth].include?(passport['ecl']) &&
        passport['pid'].to_s.match(/^[0-9]{9}$/) &&
        passport['hcl'].to_s.match(/^#[0-9a-f]{6}$/) &&
        { 'cm' => (150..193), 'in' => (59..76) }
          .fetch(String(String(passport['hgt']).match(/(cm|in)/)), [])
          .include?(Integer(String(passport['hgt'].match(/\d+/))))
      end
  end
end

solver = PassportProcessing.new
puts "PART I: #{solver.part1}"
puts "PART II: #{solver.part2}"
