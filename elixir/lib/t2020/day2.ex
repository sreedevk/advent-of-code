defmodule T2020.Day2 do
  def solve(1) do
    dstream()
    |> Enum.filter(&valid_password?(&1, 1))
    |> Enum.count
  end

  def solve(2) do
    dstream()
    |> Enum.filter(&valid_password?(&1, 2))
    |> Enum.count
  end

  def valid_password?(password_meta, 1) do
    %{"min" => min, "max" => max, "chr" => chr, "pass" => passwd} = Regex.named_captures(
      ~r/(?<min>\d+)\-(?<max>\d+)\s(?<chr>\w)\:\s(?<pass>.*)/,
      password_meta
    )

    chr_count = 
      passwd
      |> String.graphemes
      |> Enum.count(&(&1==chr))

    chr_count >= String.to_integer(min) && chr_count <= String.to_integer(max)
  end

  def valid_password?(password_meta, 2) do
    %{"pos1" => pos1, "pos2" => pos2, "chr" => chr, "pass" => passwd} = Regex.named_captures(
      ~r/(?<pos1>\d+)\-(?<pos2>\d+)\s(?<chr>\w)\:\s(?<pass>.*)/,
      password_meta
    )
    case String.at(passwd, String.to_integer(pos1) - 1) == chr do
      true -> case String.at(passwd, String.to_integer(pos2) - 1) == chr do
        true -> false
        false -> true
      end
      false -> case String.at(passwd, String.to_integer(pos2) - 1) == chr do
        true -> true
        false -> false
      end
    end
  end

  defp dstream do
    File.stream!("data/2020/day2.txt")
    |> Stream.map(&String.trim(&1))
  end
end
