class SonarSweep
  def data
    @data ||= ARGF.readlines.map(&:to_i)
  end

  def solve_1
    data.each_cons(2).count { _2 > _1 }
  end

  def solve_2
    data.each_cons(3).map(&:sum).each_cons(2).count { _2 > _1 }
  end
end

solver = SonarSweep.new
puts "PART I: #{solver.solve_1}"
puts "PART II: #{solver.solve_2}"
