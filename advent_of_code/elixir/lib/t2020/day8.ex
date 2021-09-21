defmodule T2020.Day8 do
  def solve(1) do
    fetch_instructions()
    |> parse_instructions()
    |> emulate(%{pc: 0, acc: 0})
  end

  defp parse_instructions(raw_seq) do
    raw_seq
    |> Enum.map(fn [instruction, arg] -> 
      [:unexec, String.to_atom(instruction), String.to_integer(arg)]
    end)
  end

  defp emulate(instructions, machine) do
    case Enum.fetch(instructions, machine.pc) do
      {:ok, [:unexec | instruction]} ->
        updated_instructions = update_instructions(instructions, machine)
        post_exec_machine = exec(instruction, machine)
        emulate(updated_instructions, post_exec_machine)
      {:ok, [:exec | _instr]} -> machine
      :error -> machine
    end
  end

  defp update_instructions(instructions, machine) do
    List.update_at(instructions, machine.pc, fn instruction ->
      List.update_at(instruction, 0, fn _instr -> 
        :exec
      end)
    end)
  end

  defp exec([:jmp, arg], machine), do: %{pc: arg, acc: machine.acc}
  defp exec([:nop, _ar], machine), do: %{pc: machine.pc + 1, acc: machine.acc}
  defp exec([:acc, arg], machine), do: %{pc: machine.pc + 1, acc: machine.acc + arg}

  defp fetch_instructions do
    File.stream!("data/2020/day8.txt")
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.split(&1, " "))
  end
end
