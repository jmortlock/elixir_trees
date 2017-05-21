defmodule Trees.ClosureTable do
  def descendants(tree, node) do
    Enum.filter(tree, fn(x) -> x.level != 0 && x.ancestor.id == node.id end) |> Enum.reverse
  end

  def ascendants(tree, node) do
    Enum.filter(tree, fn(x) -> x.level != 0 && x.descendant.id == node.id end) |> Enum.reverse
  end

  def from_adjacency_list(tree) do
    reduce_self_nodes(tree) ++ reduce_children_nodes(tree)
  end

  defp reduce_children_nodes(tree) do
    Enum.reduce(tree, [], fn(x, accc) -> walk_children(x, Trees.AdjacencyList.children(x, tree), tree, 1, accc) end)
  end

  defp reduce_self_nodes(tree) do
    Enum.map(tree, fn(x) -> %{ancestor: x, descendant: x, level: 0} end)
  end

  defp walk_children(_, [], _, _, acc) do
    acc |> Enum.reverse
  end

  defp walk_children(root, nodes, tree, level, acc) do
    acc = reduce_level(root, nodes, level, acc)
    next_level = Enum.flat_map(nodes, fn(child) -> Trees.AdjacencyList.children(child, tree) end)
    walk_children(root, next_level, tree, level + 1, acc)
  end

  defp reduce_level(root, nodes, level, acc) do
    Enum.reduce(nodes, acc, fn(x, accc) -> [%{ancestor: root, descendant: x, level: level} | accc] end)
  end
end
