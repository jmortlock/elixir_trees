defmodule Trees.AdjacencyList do
  def walk_tree(mode \\ :dfs, tree, start \\ nil, visit \\ fn(x) -> x end)
  def walk_tree(:bfs, tree, start, visit) do
    walk_tree_bfs(tree, visit, start)
  end

  def walk_tree(:dfs, tree, start, visit) do
    walk_tree_dfs(tree, visit, start)
  end

  def roots(tree) do
    tree |> Enum.filter(&(is_nil(&1.parent_id)))
  end

  def ascendants(node, tree, acc \\ [])
  def ascendants(nil, _, acc) do
    compact(acc) |> Enum.reverse
  end

  def ascendants(node, tree, acc) do
    parent_node = parent(node, tree)
    ascendants(parent_node, tree, [parent_node | acc])
  end

  def self_and_ascendants(node, tree) do
    ascendants(node, tree, [node])
  end

  def descendants(node, tree, acc \\ [])
  def descendants(node, tree, acc) do
    children = children(node, tree)
    List.foldl(children, Enum.into(acc, children), fn(x, accc) -> descendants(x, tree, accc) end)
    |> Enum.reverse
  end

  def siblings(%{parent_id: parent_id}  = node, tree) when is_nil(parent_id) do
    roots(tree) -- [node]
  end

  def siblings(node, tree) do
    children(node, tree)
  end

  def generations(tree) do
    tree |> Enum.group_by(fn(x) -> tree_level(x, tree) end)
  end

  def leaf?(node, tree) do
    children(node, tree) |> Enum.empty?
  end

  def root?(%{parent_id: parent_id}) when is_nil(parent_id), do: true
  def root?(_), do: false

  def tree_level(node, tree) do
    ascendants(node, tree) |> Enum.count
  end

  def parent(node, tree) do
    find_by_id(tree, node.parent_id)
  end

  def children(node, tree) do
    tree |> Enum.filter(&(&1.parent_id == node.id))
  end

  defp find_by_id(tree, id) do
    tree |> Enum.find(&(&1.id == id))
  end

  defp compact(tree) do
    Enum.reject(tree, &(is_nil(&1)))
  end

  defp walk_tree_bfs(tree, visit, nil) do
    walk_nodes_bfs(tree, roots(tree), visit)
  end

  defp walk_tree_bfs(tree, visit, node) do
    walk_nodes_bfs(tree, children(node, tree), visit)
  end

  defp walk_nodes_bfs(tree, nodes, visit, acc \\ [])
  defp walk_nodes_bfs(_, [], _, acc), do: acc
  defp walk_nodes_bfs(tree, nodes, visit, acc) do
    filtered = Enum.filter(nodes, visit)
    next_level = Enum.flat_map(filtered, fn(child) -> children(child, tree) end)
    walk_nodes_bfs(tree, next_level, visit, acc ++ filtered)
  end

  defp walk_tree_dfs(tree, visit, nil) do
    walk_nodes_dfs(tree, roots(tree), visit)
  end

  defp walk_tree_dfs(tree, visit, start) do
    if (visit.(start)) do
      walk_nodes_dfs(tree, children(start, tree), visit, [start])
    else
      []
    end
  end

  def walk_nodes_dfs(tree, nodes, visit, acc \\ [])
  def walk_nodes_dfs(_, [], _, acc), do: acc
  def walk_nodes_dfs(tree, nodes, visit, acc) do
    Enum.reduce(nodes, acc, fn(child, accc) ->
      if visit.(child) do
        walk_nodes_dfs(tree, children(child, tree), visit, [child | accc])
      else
        accc
      end
    end)
    |> Enum.reverse
  end

end
