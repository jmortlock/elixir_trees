defmodule Trees.AdjancencyList do
  def ascendants(node, list, acc \\ [])
  def ascendants(nil, _, acc) do
    compact(acc) |> Enum.reverse
  end

  def ascendants(node, list, acc) do
    parent = find_by_id(list, node.parent_id)
    ascendants(parent, list, [parent | acc])
  end

  def descendants(node, list, acc \\ [])
  def descendants(node, list, acc) do
    children = find_children(node, list)
    List.foldl(children, Enum.into(acc, children), fn(x, accc) -> descendants(x, list, accc) end)
    |> Enum.reverse
  end

  defp find_children(node, list) do
    Enum.filter(list, &(&1.parent_id == node.id))
  end

  defp find_roots(list) do
    Enum.filter(list, &(is_nil(&1.parent_id)))
  end

  defp find_by_id(list, parent_id) do
    Enum.find(list, &(&1.id == parent_id))
  end

  defp compact(list) do
    Enum.reject(list, &(is_nil(&1)))
  end
end
