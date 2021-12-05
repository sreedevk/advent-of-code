defmodule Aoc.Twenty21.Day4 do
  # --- PART I  ---

  def solve(1) do
    emulate_p1(parse_data(data()))
  end

  def solve(2), do: nil

  def emulate_p1([inputs, boards]) do
    if Enum.any?(boards, &won?/1) do
      boards
    else
      [next_call | remaining_calls] = inputs
      emulate_p1([remaining_calls, Enum.map(boards, &mark(&1, next_call))])
    end
  end

  # --- BOARD HELPERS ---
  def mark(board, num) do
    Enum.map(board, fn row ->
      Enum.map(row, fn [cell, state] ->
        if cell == num && state == false do
          [num, true]
        else
          [cell, state]
        end
      end)
    end)
  end

  def won?(board) do
    Enum.any?([board, transpose(board)], fn boardvar ->
      Enum.any?(boardvar, fn rows ->
        Enum.all?(rows, fn [_num, marked] -> marked end)
      end)
    end)
  end

  def transpose(board), do: Enum.map(List.zip(board), &Tuple.to_list/1)

  # --- DATA PARSING ---

  def parse_data(raw_data) do
    [raw_inputs | raw_boards] = raw_data
    { parse_inputs(raw_inputs), parse_boards(raw_boards) }
  end

  def parse_inputs(raw_inputs) do
    String.split(raw_inputs, ",", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  def parse_boards(raw_boards) do
    Enum.map(raw_boards, fn board ->
      String.split(board, "\n", trim: true)
      |> Enum.map(fn row ->
        String.split(row, ~r/\s+/, trim: true)
        |> Enum.map(fn cell ->
          [String.to_integer(cell), false]
        end)
      end)
    end)
  end

  def data do
    String.split(Aoc.Utils.Data.read!(__MODULE__), "\n\n")
  end
end
