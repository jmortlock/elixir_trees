defmodule Trees.AdjancencyList do

  def walk_tree(mode \\ :dfs, list, visit, start \\ nil)
  def walk_tree(:bfs, list, visit, start) do
    walk_tree_bfs(list, visit, start)
  end

  def walk_tree(:dfs, list, visit, start) do
    walk_tree_dfs(list, visit, start)
  end

  def roots(list) do
    list |> Enum.filter(&(is_nil(&1.parent_id)))
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
    list |> Enum.group_by(fn(x) -> tree_level(x, list) end)
  end

  def leaf?(node, list) do
    children(node, list) |> Enum.any?
  end

  def root?(%{parent_id: parent_id}) when is_nil(parent_id), do: true
  def root?(_), do: false

  def tree_level(node, list) do
    ascendants(node, list) |> Enum.count
  end

  defp children(node, list) do
    list |> Enum.filter(&(&1.parent_id == node.id))
  end

  defp find_by_id(list, parent_id) do
    list |> Enum.find(&(&1.id == parent_id))
  end

  defp compact(list) do
    Enum.reject(list, &(is_nil(&1)))
  end


    defp walk_tree_bfs(list, visit, nil) do
      walk_nodes_bfs(list, roots(list), visit)
    end

    defp walk_tree_bfs(list, visit, node) do
      walk_nodes_bfs(list, children(node, list), visit)
    end

    defp walk_nodes_bfs(list, nodes, visit, level \\ 0)
    defp walk_nodes_bfs(_, [], _, _), do: nil
    defp walk_nodes_bfs(list, nodes, visit, level) do
      nodes_to_walk = Enum.map(nodes,
        fn(child) ->
          visit.(child, level)
          children(child, list)
        end)
      |> List.flatten

      walk_nodes_bfs(list, nodes_to_walk, visit, level + 1)
    end

    defp walk_tree_dfs(list, visit, nil) do
      walk_nodes_dfs(list, roots(list), visit)
    end

    defp walk_tree_dfs(list, visit, start) do
      visit.(start, 0)
      walk_nodes_dfs(list, children(start, list), visit, 1)
    end

    def walk_nodes_dfs(list, nodes, visit, level \\ 0)
    def walk_nodes_dfs(_, [], _, _), do: nil
    def walk_nodes_dfs(list, nodes, visit, level) do
      Enum.each(nodes, fn(child) ->
        visit.(child, level)
        walk_nodes_dfs(list, children(child, list), visit, level + 1)
      end)
    end
end
