defmodule TreesTest do
  use ExUnit.Case

  setup do
    [
      list_a: [
        %{id: 0, parent_id: nil},
        %{id: 1, parent_id: 0},
        %{id: 2, parent_id: 1},
      ],
      list_b: [
        %{id: 3, parent_id: nil},
        %{id: 4, parent_id: 3 }
      ]
    ]
  end

  setup _context do
    :ok
  end

  test "can traverse children", context do
    list = context[:list_a]
    root_node = List.first(list)
    children = Trees.AdjancencyList.descendants(root_node, list)
    assert children == [Enum.at(list, 1)] ++ [Enum.at(list, 2)]
  end

  test "can traverse parents", context do
    list = context[:list_a]
    child_node = List.last(list)
    parents = Trees.AdjancencyList.ascendants(child_node, list)
    assert parents == [Enum.at(list, 1)] ++ [Enum.at(list, 0)]
  end

  test "can_handle multiple trees", context do
    list = context[:list_a] ++ context[:list_b]
    list_b = context[:list_b]
    root_node = List.first(context[:list_b])
    children = Trees.AdjancencyList.descendants(root_node, list)
    assert children == [Enum.at(list_b, 1)]
  end

  test "siblings of root node", context do
    list = context[:list_a] ++ context[:list_b]

    list_a_root = List.first(context[:list_a])
    list_b_root = List.first(context[:list_b])

    siblings = Trees.AdjancencyList.siblings(list_a_root, list)
    assert siblings == [list_b_root]

  end
end
