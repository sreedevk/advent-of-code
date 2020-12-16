require 'pry'

class TicketTranslation
  attr_accessor :rules, :my_ticket, :nearby_tickets, :final_assignment
  def initialize
    data_file = File.open(ARGV[0], 'r')
    rules, my_ticket, nearby_tickets = data_file.read.split("\n\n")
    data_file.close

    # parse rules
    @rules = rules.lines.inject({}) do |mem, rule|
      mem[rule.match(/[a-zA-Z\s+]*/).to_s] = rule.scan(/\d+\-\d+/).to_a.map do |range|
        Range.new(*range.split('-').map(&:to_i))
      end
      mem
    end

    # parse my ticket
    @my_ticket = my_ticket.lines[1].split(',').map(&:to_i)

    # parse nearby tickets
    @nearby_tickets = nearby_tickets.lines[1..].map do |nearby_ticket|
      nearby_ticket.split(',').map(&:to_i)
    end
  end

  def departure_field_product
    match_fields.select{|index, rule_def| rule_def[0].match(/departure/) }.keys.map {|key| @my_ticket[key] }.inject(:*)
  end

  def match_fields
    return @final_assignment if @final_assignment

    assigned_fields = {}
    (0..@my_ticket.length.pred).map do |field_index|
      field_values = valid_tickets.map do |nearby_ticket|
        nearby_ticket[field_index]
      end
      # rule ranges where all field values are covered
      possible_fields = @rules.select do |fname, frange|
        field_values.all? do |fval|
          frange[0].cover?(fval) || frange[1].cover?(fval)
        end
      end
      assigned_fields[field_index] = possible_fields
    end
    
    @final_assignment = {}
    assigned_keys = []
    
    while assigned_keys.length < @my_ticket.length
      assigned_fields.map do |field_index, field_rules|
        if (field_rules.keys - assigned_keys).length == 1
          assignment_key = (field_rules.keys - assigned_keys)[0]
          final_assignment[field_index] = field_rules.find{|k, v| k == assignment_key}
          assigned_keys << assignment_key
        end
      end
    end

    @final_assignment
  end

  def rule_ranges
    @rule_ranges ||= @rules.values.flatten
  end

  def valid_tickets
    @valid_tickets ||= nearby_tickets.select do |nearby_ticket|
      nearby_ticket.all? do |number_on_ticket|
        rule_ranges.any? do |rule_range|
          rule_range.cover?(number_on_ticket)
        end
      end
    end
  end

  def error_scanning_rate
    @nearby_tickets.flatten.select do |number_on_ticket|
      rule_ranges.none? do |rule_range|
        rule_range.cover?(number_on_ticket)
      end
    end.sum
  end
end

w = TicketTranslation.new
puts "part1: ERROR_SCANNING_RATE: #{w.error_scanning_rate}" 
puts

puts "part2: DEPARTURE_FIELD_PRODUCT: #{w.departure_field_product}"
