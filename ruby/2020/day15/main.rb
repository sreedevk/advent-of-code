require 'pry'

class RambunctiousRecitation
  def data
    @data ||= File.open('./data.txt').read.split(',').map(&:to_i)
  end

  def initialize
    reset
  end

  def reset
    @rec_map = {}
    data.dup.map.with_index {|value, index| @rec_map[value] = [index.next] }
  end

  def recite(n)
    last_recited_number = nil
    init_turns = data.length

    (n - init_turns).times do |n_index|
      if (previous_occ_indices=@rec_map[last_recited_number]) && previous_occ_indices.length > 1
        next_num = previous_occ_indices.last(2).sort.reverse.inject(:-)
      else
        next_num = 0
      end
      last_recited_number = next_num
      @rec_map[next_num]  = (@rec_map[next_num] && @rec_map[next_num].last(2)) || []
      @rec_map[next_num] << (init_turns + n_index.next)
    end
    return last_recited_number
  end
end

rr = RambunctiousRecitation.new
p rr.recite(2020)

GC.start

rr = RambunctiousRecitation.new
p rr.recite(30000000)
