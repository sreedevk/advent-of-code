defmodule T2020.Day7 do
  @childbag_match Regex.recompile!(~r/^(?<count>\d+)\s(?<bag>[a-zA-Z ]*)\s(bag|bags).*$/)

  def solve(1) do
    graph = dstream() |> generate_graph(:digraph.new)
    get_ancestors(graph, "shiny gold")
    |> Enum.count()
  end

  # NOTE: INCOMPLETE
  def solve(2) do
    dstream()
    |> generate_graph(:digraph.new)
    |> encompassed_bags_count("shiny gold")
  end

  # private functions
  defp encompassed_bags_count(graph, parent_bag) do
    :digraph_utils.reachable([parent_bag], graph)
    |> Enum.filter(&(&1 != parent_bag))
    |> Enum.map(&:digraph.get_path(graph, parent_bag, &1)) # sink vertex for graph may not be sink vertex for parent
    |> Enum.filter(&complete_path?(graph, &1))
    |> Enum.map(&paths_to_edges(graph, &1))
    |> edge_paths_value
  end

  defp complete_path?(graph, path) do
    Enum.empty?(:digraph.out_edges(graph, List.last(path)))
  end

  defp edge_paths_value(edge_paths) do
    # TODO
    edge_paths
  end

  defp paths_to_edges(graph, path) do
    path
    |> Enum.with_index
    |> Enum.map(fn {iter_parent, index} -> 
      case Enum.fetch(path, index + 1) do
        {:ok, next_child} -> 
          get_edges(graph, iter_parent, next_child)
        :error -> nil
      end
    end)
    |> Enum.filter(&(&1))
  end

  defp get_edges(graph, parent_vertex, child_vertex) do
    :digraph.out_edges(graph, parent_vertex)
    |> Enum.map(&format_edge(graph, &1))
    |> Enum.filter(fn [child, _label] -> 
      child == child_vertex
    end)
    |> List.flatten
  end

  defp format_edge(graph, edge) do
    :digraph.edge(graph, edge)
    |> Tuple.to_list
    |> Enum.slice(2,3)
  end

  defp get_ancestors(graph, bag) do
    :digraph.vertices(graph)
    |> Enum.filter(&(is_list(:digraph.get_path(graph, &1, bag))))
  end

  defp dstream do
    File.stream!("data/2020/day7.txt")
    |> Stream.map(&String.trim(&1))
    |> Enum.map(&String.split(&1, " bags contain ", trim: true))
  end

  defp generate_graph(bag_rules, graph) do
    bag_rules |> Enum.map(fn [parent, children_meta] -> 
      :digraph.add_vertex(graph, parent)
      Enum.map(parse_children(children_meta), fn child -> 
        :digraph.add_vertex(graph, Map.fetch!(child, "bag"))
        :digraph.add_edge(graph, parent, Map.fetch!(child, "bag"), String.to_integer(Map.fetch!(child, "count")))
      end)
    end)
    graph
  end

  defp parse_children("no other bags."), do: []
  defp parse_children(children_info) do
    String.split(children_info, ", ")
    |> Enum.map(&Regex.named_captures(@childbag_match, &1))
  end
end
