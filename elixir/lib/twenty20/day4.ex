defmodule Aoc.Twenty20.Day4 do
  @required_fields ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"] # "cid"
  @byr_range Range.new(1920, 2002)
  @iyr_range Range.new(2010, 2020)
  @eyr_range Range.new(2020, 2030)
  @hgt_cm_range Range.new(150, 193)
  @hgt_in_range Range.new(59, 76)
  @hgt_match Regex.recompile!(~r/^(?<num>\d+)(?<unit>(cm|in))$/)
  @hcl_match Regex.recompile!(~r/^\#[a-fA-F0-9]{6}$/)
  @ecl_match Regex.recompile!(~r/^(amb|blu|brn|gry|grn|hzl|oth)$/)
  @pid_match Regex.recompile!(~r/^\d{9}$/)

  def solve(1) do
    dstream()
    |> Enum.filter(&valid_passport?(&1))
    |> Enum.count
  end

  def solve(2) do
    dstream()
    |> Enum.filter(&valid_passport?/1)
    |> Enum.filter(&valid_byr?/1)
    |> Enum.filter(&valid_iyr?/1)
    |> Enum.filter(&valid_eyr?/1)
    |> Enum.filter(&valid_hgt?/1)
    |> Enum.filter(&valid_hcl?/1)
    |> Enum.filter(&valid_ecl?/1)
    |> Enum.filter(&valid_pid?/1)
    |> Enum.count
  end

  # private functions
  defp valid_passport?(passport) do
    @required_fields |> Enum.all?(&Map.has_key?(passport, &1))
  end

  defp valid_pid?(passport) do
    Regex.match?(@pid_match, Map.fetch!(passport, "pid"))
  end

  defp valid_ecl?(passport) do
    Regex.match?(@ecl_match, Map.fetch!(passport, "ecl"))
  end

  defp valid_hcl?(passport) do
    Regex.match?(@hcl_match, Map.fetch!(passport, "hcl"))
  end

  defp valid_hgt?(passport) do
    case Regex.named_captures(@hgt_match, Map.fetch!(passport, "hgt")) do
      nil -> false
      %{"unit" => unit, "num" => num} -> case unit do
        "cm" -> case String.to_integer(num) do
          num when num in @hgt_cm_range -> true
          _ -> false
        end
        "in" -> case String.to_integer(num) do
          num when num in @hgt_in_range -> true
          _ -> false
        end
      end
    end
  end

  defp valid_byr?(passport) do
    case Map.fetch!(passport, "byr") |> String.to_integer do
      byr when byr in @byr_range -> true
      _ -> false
    end
  end

  defp valid_iyr?(passport) do
    case Map.fetch!(passport, "iyr") |> String.to_integer do
      iyr when iyr in @iyr_range -> true
      _ -> false
    end
  end

  defp valid_eyr?(passport) do
    case Map.fetch!(passport, "eyr") |> String.to_integer do
      eyr when eyr in @eyr_range -> true
      _ -> false
    end
  end

  defp dstream do
    prepare_data(Aoc.Utils.Data.read!(__MODULE__))
  end

  defp prepare_data(content) do
    content
    |> String.split("\n\n")
    |> Enum.map(&create_passport(&1))
  end

  defp create_passport(passport_meta) do
    Regex.split(~r/\s+/, passport_meta)
    |> Enum.filter(&(&1 != ""))
    |> Enum.reduce(%{}, fn attr, ppt -> 
      [key, val] = String.split(attr, ":")
      Map.put(ppt, key, val)
    end)
  end
end
