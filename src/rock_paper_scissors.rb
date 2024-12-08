# frozen_string_literal: true

# AoC 2022 Day 2
class RockPaperScissors
  attr_accessor :data

  SIGN_SCORES = %i[rock paper scissors].freeze
  STRATEGIES  = {
    rock: :scissors,
    scissors: :paper,
    paper: :rock
  }.freeze

  def initialize(data)
    @data = data.lines.map(&:strip)
  end

  def solve1
    data
      .lazy
      .map { |input| input.split(' ').map(&method(:to_sym)) }
      .map { |input| score(*input) }
      .sum
  end

  def solve2
    data
      .lazy
      .map { |input| input.split(' ') }
      .map { |input| syms(*input) }
      .map { |input| score(*input) }
      .sum
  end

  private

  def syms(player0, outcome)
    player0_sym = to_sym(player0)
    case outcome
    when 'X'
      [player0_sym, STRATEGIES[player0_sym]]
    when 'Y'
      [player0_sym, player0_sym]
    when 'Z'
      [player0_sym, STRATEGIES.key(player0_sym)]
    end
  end

  def score(player0, player1)
    return SIGN_SCORES.index(player1) + 1 if STRATEGIES[player0] == player1
    return SIGN_SCORES.index(player1) + 4 if player0 == player1

    SIGN_SCORES.index(player1) + 7 if STRATEGIES.key(player0) == player1
  end

  def to_sym(raw)
    case raw
    when 'A', 'X'
      :rock
    when 'B', 'Y'
      :paper
    when 'C', 'Z'
      :scissors
    end
  end
end
