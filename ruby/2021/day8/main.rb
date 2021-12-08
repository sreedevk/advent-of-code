require 'pry'

class SevenSegmentSearch
  # length => numbers
  SEG_COUNT_NUMS = {
    2 => [1],
    3 => [7],
    4 => [4],
    5 => [2, 3, 5],
    6 => [0, 6, 9],
    7 => [8]
  }

  def part1
    data.inject(0) do |acc, signals|
      acc + signals[1].count { |signal| SEG_COUNT_NUMS[signal.length].length == 1 } 
    end
  end

  def part2
    data.inject(0) do |acc, signals|
      signal_map = deduce_signal_map(signals[0])
      acc + signals[1].map { signal_map[_1.chars.sort.join] }.join.to_i
    end
  end

  def deduce_signal_map(signals)
    unpacked_signals  = signals.map(&:chars)
    signals_map       = map_known_numbers(unpacked_signals)
    ambi_signals      = unpacked_signals.filter { SEG_COUNT_NUMS[_1.length].length > 1 }

    # length: 6
    signals_map[6] = 
      ambi_signals.group_by(&:length)[6]
      .find { |iter_signal| (iter_signal & signals_map[1]).length == 1 }

    ambi_signals.reject!{ _1.eql?(signals_map[6]) }

    signals_map[0] =
      ambi_signals.group_by(&:length)[6]
      .find { |iter_signal| !(iter_signal & signals_map[4]).sort.eql?(signals_map[4].sort) }

    ambi_signals.reject! { _1.eql?(signals_map[0]) }

    signals_map[9] =
      ambi_signals.group_by(&:length)[6][0]

    # length: 5
    signals_map[3] =
      ambi_signals.group_by(&:length)[5]
      .find { |iter_signal| (signals_map[1] & iter_signal).length == 2 }

    ambi_signals.reject!{ _1.eql?(signals_map[3]) } 

    signals_map[5] = 
      ambi_signals.group_by(&:length)[5]
      .find { |iter_signal| ((signals_map[1] & signals_map[6]) & iter_signal).length == 1 }

    ambi_signals.reject!{ _1.eql?(signals_map[5]) }

    signals_map[2] = ambi_signals.group_by(&:length)[5][0]
    signals_map.transform_values(&:sort).transform_values(&:join).invert
  end

  def map_known_numbers(signals)
    signals
      .filter { SEG_COUNT_NUMS[_1.length].length == 1 }
      .inject({}) do |memory, signal|
        memory.merge({ SEG_COUNT_NUMS[signal.length][0] => signal })
      end
  end

  def data
    @data ||= ARGF.readlines.map(&:strip).map {|line| line.split("|").map(&:strip).map {|digits| digits.split(" ").map(&:strip) } }
  end
end

solver = SevenSegmentSearch.new
pp solver.part1
pp solver.part2
