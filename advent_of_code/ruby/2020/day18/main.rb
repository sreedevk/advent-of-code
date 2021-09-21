require 'pry'

class OperationOrder
  ADDITION       = '+'
  MULTIPLICATION = '*'
  OPERATORS      = [ADDITION, MULTIPLICATION]

  def initialize(op)
    @order_of_precedence = op
  end

  def data
    @data ||= File.open("#{ARGV[0]}", 'r').readlines
  end

  def solve_simple_using_op(tokens)
    operated_tokens = tokens.dup
    while(operated_tokens.size > 1)
      @order_of_precedence.length.times.map do |selected_op_index|
        index = 0
        loop do
          break if operated_tokens[index].nil?

          if operated_tokens[index] == @order_of_precedence[selected_op_index]
            left_operand, right_operand = operated_tokens[index.pred], operated_tokens[index.next]
            operated_tokens[index.pred..index.next] = eval("#{left_operand} #{@order_of_precedence[selected_op_index]} #{right_operand}")
            index = 0
          else
            index += 1
          end
        end
      end
    end
    return operated_tokens[0]
  end

  def solve(tokens)
    return solve_simple_using_op(tokens) if tokens.none? {|tk| tk == '('  || tk == ')' }

    operated_tokens = tokens.dup
    while(operated_tokens.include?('(') || operated_tokens.include?(')'))
      inner_most_set_start_index = operated_tokens.map.with_index {|token, index| index if token == '(' }.compact.last
      matching_end_index         = inner_most_set_start_index + 
        operated_tokens[inner_most_set_start_index..].map.with_index {|token, index| index if token == ')'}.compact.first
      operated_tokens[matching_end_index]              = nil
      operated_tokens[inner_most_set_start_index]      = nil
      operated_tokens[inner_most_set_start_index.next..matching_end_index.pred] = solve_simple_using_op(
        operated_tokens[inner_most_set_start_index.next..matching_end_index.pred]
      )
      operated_tokens.compact!
    end
    return solve_simple_using_op(operated_tokens)
  end


  def solve_problems
    data.map do |problem|
      tokens = problem.chars.map(&:strip).reject(&:empty?)
      solve(tokens)
    end
  end
end

p1 = OperationOrder.new(['*', '+'])
puts "part1: #{p1.solve_problems.sum}"

p2 = OperationOrder.new(['+', '*'])
puts "part2: #{p2.solve_problems.sum}"
