class Ship
  attr_accessor :position, :facing
  @@directions            = [:n, :e, :s, :w]
  @@directional_positives = [:e, :n]
  @@directional_negatives = [:w, :s]

  def initialize
    #            x, y
    @position = [0, 0]
    @facing   = :e
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
    @facing = @@directions[(@@directions.index(@facing)+(angle/90)) % @@directions.length]
  end

  def l(angle)
    @facing = @@directions[(@@directions.index(@facing)-(angle/90)) % @@directions.length]
  end

  def e(arg)
    @position[0] += arg
  end

  def n(arg)
    @position[1] += arg
  end

  def f(arg)
    arg = (arg * -1) if @@directional_negatives.include?(@facing)
    @position[((%i[e w].include?(@facing) && 0) || 1)] += arg
  end

  def manhattan_distance
    @position.map(&:abs).sum
  end
end

ship = Ship.new
ship.load_instructions
ship.navigate

puts ship.position.inspect
puts ship.manhattan_distance
