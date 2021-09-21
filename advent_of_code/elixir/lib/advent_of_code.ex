defmodule AdventOfCode do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      T2017.Day1
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: AdventOfCode.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
