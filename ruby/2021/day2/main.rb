class Dive
  def data
    @data ||= ARGF.readlines.map(&:strip)
  end

  def solve_1
    data
      .map { processor[0].send(:[], "#{_1.match /^.*(?=\s)/}").("#{_1.match /(?<=\s).*$/}".to_i) }
      .inject([0,0]) { [_1[0]+_2[0], _1[1]+_2[1]] }
      .inject(&:*)
  end

  def solve_2
    data
      .inject([0,0,0]) { processor[1].send(:[], "#{_2.match /^.*(?=\s)/}").(_1, "#{_2.match /(?<=\s).*$/}".to_i) }
      .slice(0..1)
      .inject(&:*)
  end

  def processor
    @processor ||= [
      {'forward'=>->{[_1,0]},'up'=>->{[0,-_1]},'down'=>->{[0,_1]}},
      {'forward'=>-> {[_1[0]+_2,_1[1]+_1[2]*_2,_1[2]]},'up'=>-> {[_1[0],_1[1],_1[2]-_2]}, 'down'=>->{[_1[0],_1[1],_1[2]+_2]}}
    ]
  end
end

solver = Dive.new
puts "PART I: #{solver.solve_1}"
puts "PART II: #{solver.solve_2}"
