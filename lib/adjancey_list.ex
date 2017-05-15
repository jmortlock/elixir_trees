defmodule Trees.AdjancencyList do
  def walk_tree_bfs(list, visit, node \\ nil, level \\ -1) do
    nodes = if is_nil(node) do
      roots(list)
    else
      children(node, list)
    end
    Enum.each(nodes, fn(child) -> visit.(child, level + 1) end)
    Enum.each(nodes, fn(child) -> walk_tree_bfs(list, visit, child, level + 1) end)
  end

  def walk_tree_dfs(list, visit, node \\ nil, level \\ -1) do
    unless level == -1 do
      visit.(node, level)
    end

    nodes = if is_nil(node) do
      roots(list)
    else
      children(node, list)
    end
    Enum.each(nodes, fn(child) -> walk_tree_dfs(list, visit, child, level + 1) end)
  end


  def roots(list) do
    Enum.filter(list, &(is_nil(&1.parent_id)))
  end

  def ascendants(node, list, acc \\ [])
  def ascendants(nil, _, acc) do
    compact(acc) |> Enum.reverse
  end

  def ascendants(node, list, acc) do
    parent = find_by_id(list, node.parent_id)
    ascendants(parent, list, [parent | acc])
  end

  def self_and_ascendants(node, list) do
    ascendants(node, list, [node])
  end

  def descendants(node, list, acc \\ [])
  def descendants(node, list, acc) do
    children = children(node, list)
    List.foldl(children, Enum.into(acc, children), fn(x, accc) -> descendants(x, list, accc) end)
    |> Enum.reverse
  end

  def siblings(%{parent_id: parent_id}  = node, list) when is_nil(parent_id) do
    roots(list) -- [node]
  end

  def siblings(node, list) do
    children(node, list)
  end

  def generations(list) do
    Enum.group_by(list, fn(x) -> tree_level(x, list) end)
  end

  def tree_level(node, list) do
    ascendants(node, list) |> Enum.count
  end

  defp children(node, list) do
    Enum.filter(list, &(&1.parent_id == node.id))
  end

  defp find_by_id(list, parent_id) do
    Enum.find(list, &(&1.id == parent_id))
  end

  defp compact(list) do
    Enum.reject(list, &(is_nil(&1)))
  end
end
