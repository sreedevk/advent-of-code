class SyntaxScoring
  def initialize
    @tokens      = "()[]{}<>".unpack("C*")
    @tokengroups = @tokens.each_slice(2).to_a
    @otokens     = @tokengroups.map(&:min)
    @ctokens     = @tokengroups.map(&:max)
    @points      = @ctokens.zip([3, 57, 1197, 25137]).to_a.to_h
    data
  end

  def part1
    data
      .filter { _1[:type].eql?(:invalid) }
      .sum    { @points[_1[:code][0]] }
  end

  def part2
    scores = data.filter_map do |line|
      line[:type].eql?(:incomplete) &&
        line[:callstack].reverse.reduce(0) { |acc, token| (acc * 5) + @otokens.index(token).next }
    end
        
    scores.sort[scores.count/2]
  end

  private

  def parse(callstack, code)
    return { type: :valid, callstack: callstack, code: code} if code.empty? && callstack.empty?
    return { type: :incomplete, callstack: callstack, code: code } if code.empty? && !callstack.empty?

    if [1, 2].map { _1 + callstack[-1].to_i }.include?(code[0])
      parse(callstack.tap(&:pop), code.tap(&:shift)) 
    elsif @otokens.include?(code[0])
      parse(callstack.push(code.shift), code) 
    else
      { type: :invalid, callstack: callstack, code: code }
    end
  end

  def data
    @data ||= ARGF.readlines.map(&:strip).map { _1.unpack("C*") }.map { parse([], _1) }
  end
end

solver = SyntaxScoring.new
Process.fork { pp solver.part1 }
Process.fork { pp solver.part2 }
Process.waitall
