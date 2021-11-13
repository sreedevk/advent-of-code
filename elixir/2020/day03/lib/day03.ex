defmodule Day03 do
  def solve(1) do
    traverse(
      dstream(),
      %{row: 0, col: 0, trees: 0, traverse_pattern: %{r: 3, d: 1}}
    )
  end

  def solve(2) do
    [
      %{r: 1, d: 1},
      %{r: 3, d: 1},
      %{r: 5, d: 1},
      %{r: 7, d: 1},
      %{r: 1, d: 2}
    ]
    |> Enum.map(&traverse(dstream(), %{row: 0, col: 0, trees: 0, traverse_pattern: &1}))
    |> Enum.map(&Map.fetch!(&1, :trees))
    |> Enum.product
  end

  def traverse(map, state) do
    state = Map.put(state, :row, state.row + state.traverse_pattern.d)
    state = Map.put(state, :col, state.col + state.traverse_pattern.r)

    case Enum.fetch(map, state.row) do
      :error -> state
      {:ok, row} -> case Enum.fetch(row, rem(state.col, length(row))) do
        :error -> IO.puts("$$$ #{row}, len: #{length(row)}, col: #{state.col}, index: #{rem(length(row), state.col)}")
        {:ok, cell} ->
          if cell == "#" do
            state = Map.put(state, :trees, state.trees + 1)
            traverse(map, state)
          else
            traverse(map, state)
          end
      end
    end
  end

  def dstream do
    case File.read("data.txt") do
      {:ok, content} ->
        content
        |> String.split("\n")
        |> Enum.map(&String.trim(&1))
        |> Enum.filter(&(&1 != ""))
        |> Enum.map(&String.graphemes(&1))
      {:error, _} -> []
    end
  end
end
