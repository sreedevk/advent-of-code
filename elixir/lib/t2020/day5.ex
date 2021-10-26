defmodule T2020.Day5 do
  @seat_match Regex.recompile!(~r/^(?<row_spec>(F|B){7})(?<col_spec>(L|R){3})$/)
  def solve(1) do
    dstream()
    |> Stream.map(&get_seat_id/1)
    |> MapSet.new()
    |> Enum.max
  end

  def solve(2) do
    seats = dstream() |> Stream.map(&get_seat_id/1) |> MapSet.new()
    seats_range = MapSet.new(Range.new(Enum.min(seats), Enum.max(seats)))
    List.first(MapSet.to_list(MapSet.difference(seats_range, seats)))
  end

  defp get_seat_id(seat_spec) do
    %{"row_spec" => row_spec, "col_spec" => col_spec } = Regex.named_captures(@seat_match, seat_spec)
    {row_id, _} = Integer.parse(Regex.replace(~r/F/, Regex.replace(~r/B/, row_spec, "1"), "0"), 2)
    {col_id, _} = Integer.parse(Regex.replace(~r/L/, Regex.replace(~r/R/, col_spec, "1"), "0"), 2)
    (row_id * 8) + col_id
  end

  defp dstream do
    File.stream!("data/2020/day5.txt")
    |> Stream.map(&String.trim/1)
    |> Stream.filter(&(&1 != ""))
  end
end
