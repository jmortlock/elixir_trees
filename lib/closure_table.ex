defmodule Trees.ClosureTable do
  def from_adjacency_list(tree) do
    roots = Enum.reduce(tree, [], fn(x, accc) -> [%{ancestor: x, descendant: x, level: 0} | accc] end) |> Enum.reverse
    roots ++ Enum.reduce(tree, [], fn(x, accc) -> walk_children(x, Trees.AdjacencyList.children(x, tree), tree, 1, accc) end)
  end

  defp walk_children(_, [], _, _, acc) do
    acc |> Enum.reverse
  end

  defp walk_children(root, nodes, tree, level, acc) do
    current_level = reduce_level(root, nodes, level, acc)
    next_level = Enum.flat_map(nodes, fn(child) -> Trees.AdjacencyList.children(child, tree) end)
    walk_children(root, next_level, tree, level + 1, current_level)
  end

  defp reduce_level(root, nodes, level, acc) do
    Enum.reduce(nodes, acc, fn(x, accc) -> [%{ancestor: root, descendant: x, level: level} | accc] end)
  end
end
