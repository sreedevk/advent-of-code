class SonarSweep
  def data
    @data ||= ARGF.readlines
  end

  def solve_1
    data.each_cons(2).select {|x, y| y > x }.count
  end

  def solve_2
    data.map(&:to_i).each_cons(3).map(&:sum).each_cons(2).select {|x, y| y > x }.count
  end
end

solver = SonarSweep.new
puts "PART I: #{solver.solve_1}"
puts "PART II: #{solver.solve_2}"
