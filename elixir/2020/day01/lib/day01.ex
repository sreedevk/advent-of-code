defmodule Day01 do
  def solve(1) do
    data = dstream()
    data 
    |> Enum.filter(fn value -> Enum.member?(data, 2020 - value) end)
    |> Enum.product
  end

  def solve(2) do
    data = dstream()

    cartesian_product = for x <- data, y <- data, z <- data, do: [x, y, z]
    cartesian_product
    |> Enum.filter(fn set -> Enum.sum(set) == 2020 end)
    |> Enum.map(&Enum.sort/1)
    |> Enum.uniq
    |> Enum.map(&Enum.product/1)
    |> List.first
  end

  defp dstream do
    {:ok, data} = File.read("data.txt")

    data
    |> String.trim
    |> String.split("\n")
    |> Enum.map(&String.trim/1)
    |> Enum.map(fn strvalue -> 
      case Integer.parse(strvalue) do
        :error -> IO.inspect("cannot process: #{strvalue}")
        {value, _} -> value
      end
    end)
    |> Enum.filter(&is_integer/1)
  end
end
