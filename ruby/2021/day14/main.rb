class ExtendedPolymerization
  def part1(gens)
    mutated_comb_counts = mutate(initial_state.chars.each_cons(2).tally.transform_keys(&:join), gens)
    char_counts = mutated_comb_counts.keys.join.chars.uniq.inject({}) do |acc, indchar|
      acc.merge({indchar => mutated_comb_counts.select { _1.match(/^#{indchar}.$/) }.values.sum })
    end
    char_counts.values.minmax.inject(&:-).abs.next
  end

  def part2(gens)
    mutated_comb_counts = mutate(initial_state.chars.each_cons(2).tally.transform_keys(&:join), gens)
    char_counts = mutated_comb_counts.keys.join.chars.uniq.inject({}) do |acc, indchar|
      acc.merge({indchar => mutated_comb_counts.select { _1.match(/^#{indchar}.$/) }.values.sum })
    end
    char_counts.values.minmax.inject(&:-).abs.next
  end

  def mutate(state, gens, gen = 1)
    return state if gen > gens

    mutate(
      state.inject({}) { |acc, (comb, count)| acc.merge(combination_mutation_rules[comb].tally.transform_values { count }) { _2 + _3 } },
      gens,
      gen.next
    )
  end

  def combination_mutation_rules
    @combination_mutation_rules ||= mutation_rules.inject({}) do |acc, (combination, insertion_variant)|
      acc.merge(combination => combination.chars.insert(1, insertion_variant).each_cons(2).to_a.map(&:join))
    end
  end

  def initial_state
    @initial_state ||= data[0].strip
  end

  def mutation_rules
    @mutation_rules ||= data[1].split("\n").map { _1.strip.split(" -> ") }.to_h
  end

  def data
    @data ||= ARGF.read.split("\n\n")
  end
end

solver = ExtendedPolymerization.new
Process.fork { pp solver.part1(10) }
Process.fork { pp solver.part2(40) }
Process.waitall
