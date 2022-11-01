require 'set'

class PassagePathing
  attr_accessor :file

  def initialize
    @file = 'example.txt'
  end

  def solve
    build_paths(graph["start"])
  end

  private

  def build_paths(node, paths=[])
    paths.map {|path| path.add(node) }
  end

  def cavemap
    @cavemap ||= File
      .open(@file, 'r')
      .readlines
      .map(&:strip)
      .map { |x| x.split('-').map(&:strip) }
  end

  def graph
    @graph ||= Set[*cavemap.flatten]
      .each_with_object({}) { |node, g| g[node] = Set[] }
      .tap { |g| cavemap.map { |(from, to)| g[from].add(to) } }
  end
end

solver = PassagePathing.new
p solver.solve
