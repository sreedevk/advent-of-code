class PacketDecoder
  attr_accessor :input

  def initialize
    @input = ARGF.read
  end

  def solve
    @input.to_i(16).to_s(2)
  end
end

p PacketDecoder.new.solve
