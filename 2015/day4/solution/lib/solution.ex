defmodule Hashing do
  use Flow

  def calculate_sum(string) do
    :crypto.hash(:md5, string) |> Base.encode16()
  end

  def check_solution(checksum, string) do
    if String.match?(checksum, ~r/^0{6}/) do
      IO.puts("md5(#{string}) = #{checksum}")
      false
    else
      true
    end
  end

  def solve(key) do
    Stream.iterate(0, &(&1+1))
    |> Flow.from_enumerable()
    |> Flow.partition()
    |> Enum.take_while(fn sol -> 
      Hashing.calculate_sum("#{key}#{sol}")
      |> Hashing.check_solution("#{key}#{sol}")
    end)
  end
end

# IO.puts(Hashing.calculate_sum("abcdef609043"))
# Hashing.solve("abcdef")
Hashing.solve("bgvyzdsv")
