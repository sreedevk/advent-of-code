class Ship
  attr_accessor :waypoint, :position
  @@directional_positives = [:e, :n]
  @@directional_negatives = [:w, :s]

  def initialize
    @waypoint = [10, 1]
    @position = [0, 0]
  end

  def load_instructions
    @instructions = ARGF.readlines.map do |line|
      command, arg = line.match(/^([A-Z])(\d+)/).to_a.tap(&:shift)
      command, arg = command.downcase.to_sym, arg.to_i
      if @@directional_negatives.include?(command)
        arg = (arg * -1)
        command = @@directional_positives[@@directional_negatives.index(command)]
      end
      [command, arg]
    end
  end

  def navigate
    @instructions.map do |command, arg|
      send(command, arg)
    end
  end

  def r(angle)
    # clockwise => (x, y) = (y, -x)
    (angle/90).times do
      @waypoint[0], @waypoint[1] = @waypoint[1], @waypoint[0] * -1
    end
  end

  def l(angle)
    # counterclockwise => (x, y) = (-y, x)
    (angle/90).times do
      @waypoint[0], @waypoint[1] = @waypoint[1] * -1, @waypoint[0]
    end
  end

  def e(arg)
    @waypoint[0] = @waypoint[0].to_i + arg
  end

  def n(arg)
    @waypoint[1] = @waypoint[1].to_i + arg
  end

  def f(arg)
    @position[0] = @position[0].to_i + (@waypoint[0] * arg)
    @position[1] = @position[1].to_i + (@waypoint[1] * arg)
  end

  def manhattan_distance
    @position.map(&:abs).sum
  end
end

ship = Ship.new
ship.load_instructions
ship.navigate

puts ship.waypoint.inspect
puts ship.position.inspect
puts ship.manhattan_distance
