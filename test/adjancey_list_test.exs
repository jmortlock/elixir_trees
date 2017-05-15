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
      ],
      list_c: [
        %{id: 1, parent_id: nil, name: "a"},
        %{id: 2, parent_id: 1, name: "b"},
        %{id: 3, parent_id: 1, name: "c"},
        %{id: 4, parent_id: 2, name: "d"},
        %{id: 5, parent_id: 2, name: "e"},
        %{id: 6, parent_id: 3, name: "f"},
        %{id: 7, parent_id: 3, name: "g"},
        %{id: 8, parent_id: 5, name: "h"},

      ],
    ]
  end

  setup _context do
    :ok
  end

  test "dfs", context do
    list = context[:list_c]
    Trees.AdjancencyList.walk_tree(list, fn(x, level) -> IO.puts~s(#{x.name} - level #{level}) end)
  end

  test "bfs", context do
    list = context[:list_c]
  #  Trees.AdjancencyList.walk_tree(:bfs, list, fn(x, level) -> IO.puts~s(#{x.name} - level #{level}) end)
  end

  test "can traverse children", context do
    list = context[:list_a]
    root_node = List.first(list)
    children = Trees.AdjancencyList.descendants(root_node, list)
    assert children == Enum.slice(list, 1, 2)
  end

  test "can traverse parents", context do
    list = context[:list_a]
    child_node = List.last(list)
    parents = Trees.AdjancencyList.ascendants(child_node, list)
    assert parents == Enum.slice(list, 0, 2) |> Enum.reverse
  end

  test "self and ascendants", context do
    list = context[:list_a]
    child_node = List.last(list)
    parents = Trees.AdjancencyList.self_and_ascendants(child_node, list)
    assert parents == Enum.reverse(list)
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

  test "siblings of non-root node", context do
    list = context[:list_a]
    node = Enum.at(list, 1)
    siblings = Trees.AdjancencyList.siblings(node, list)
    assert siblings == [List.last(list)]
  end

  test "tree level", context do
    list = context[:list_a]
    node = Enum.at(list, 1)
    assert Trees.AdjancencyList.tree_level(node, list) == 1
  end

  test "generations", context do
    list = context[:list_a]
    generations = Trees.AdjancencyList.generations(list)
    expected = %{0 => [Enum.at(list, 0)], 1 => [Enum.at(list, 1)], 2 => [Enum.at(list, 2)]}
    assert generations == expected
  end
end
