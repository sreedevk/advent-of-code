# frozen_string_literal: true

# Solution
class NoSpaceLeftOnDevice
  attr_accessor :data, :cpath, :fs

  def initialize
    @data = ARGF
            .readlines
            .map(&:strip)
            .map { |command| command.split(' ') }

    @cpath = ''
    @fs = Hash.new(0)
  end

  def process_ls(_line, line_index)
    sum = data[(line_index + 1)..]
          .take_while { |x| x[0] != '$' }
          .filter { |l| l[0] != 'dir' }
          .map { |l| l[0].to_i }
          .sum

    assign_cp_size(sum)
  end

  def assign_cp_size(size)
    @cpath
      .split('/')
      .reject(&:empty?)
      .inject(['/home']) { |mpath, cdir| mpath << "#{mpath[-1]}/#{cdir}" }
      .map { |dir| @fs[dir] += size }
  end

  def process_cd(line, _line_index)
    case line [2]
    when '/'
      @cpath = ''
    when '..'
      @cpath = cpath[...cpath.rindex('/')]
    else
      @cpath += "/#{line[2]}"
    end
  end

  def process_line(line, line_index)
    return unless line[0] == '$'

    case line [1]
    when 'ls'
      process_ls(line, line_index)
    when 'cd'
      process_cd(line, line_index)
    end
  end

  def solve1
    data
      .map.with_index
      .filter { |line, _| line[0] == '$' }
      .each { |line, index| process_line(line, index) }

    fs
      .filter { |_k, v| v <= 100_000 }
      .values
      .sum
  end

  def solve2
    available_space = 70_000_000 - fs['/home']
    required_space = 30_000_000
    space_to_clear = required_space - available_space

    fs
      .filter { |_, size| size >= space_to_clear }
      .values
      .min
  end
end

solver = NoSpaceLeftOnDevice.new
puts "PART I: #{solver.solve1}"
puts "PART II: #{solver.solve2}"
