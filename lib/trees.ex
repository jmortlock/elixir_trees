defmodule Trees.List do
  def parents_of_node(node, list, acc \\ [])
  def parents_of_node(nil, _, acc) do
    compact(acc)
  end

  def parents_of_node(node, list, acc) do
    parent = find_by_id(list, node.parent_id)
    parents_of_node(parent, list, acc ++ [parent])
  end

  def children_of_node(node, list, acc \\ [])
  def children_of_node(node, list, acc) do
    children = find_children(node, list)

    acc = acc ++ children
    Enum.reduce(children, acc, fn(x, accc) -> accc ++ children_of_node(x, list) end)
      |> compact
  end

  defp find_children(node, list) do
    Enum.filter(list, &(&1.parent_id == node.id))
  end

  defp find_by_id(list, parent_id) do
    Enum.find(list, &(&1.id == parent_id))
  end

  defp compact(list) do
    Enum.reject(list, &(is_nil(&1)))
  end
end
