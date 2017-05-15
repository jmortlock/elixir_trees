defmodule TreesTest do
  use ExUnit.Case

  setup do
    [
      tree_a: [
        %{id: 0, parent_id: nil},
        %{id: 1, parent_id: 0},
        %{id: 2, parent_id: 1},
      ],
      tree_b: [
        %{id: 3, parent_id: nil},
        %{id: 4, parent_id: 3 }
      ],
      tree_c: [
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

  test "dfs from given node", context do
    list = context[:tree_c]
    start = Enum.at(list, 2)
    dfs = Trees.AdjancencyList.walk_tree(:dfs, list, start) |> Enum.map(& &1.name)
    assert dfs == ["c", "f", "g"]
  end

  test "dfs from start", context do
    list = context[:tree_c]
    dfs = Trees.AdjancencyList.walk_tree(:dfs, list) |> Enum.map(& &1.name)
    assert dfs == ["a", "b", "d", "e", "h", "c", "f", "g"]
  end

  test "bfs", context do
    list = context[:tree_c]
    bfs = Trees.AdjancencyList.walk_tree(:bfs, list) |> Enum.map(& &1.name)
    assert bfs == ["a", "b", "c", "d", "e", "f", "g", "h"]
  end

  test "bfs with filter", context do
    list = context[:tree_c]
    bfs = Trees.AdjancencyList.walk_tree(:bfs, list, nil, fn(x) -> x.name == "a" end) |> Enum.map(& &1.name)
    assert bfs == ["a"]
  end

  test "dfs with filter", context do
    list = context[:tree_c]
    dfs = Trees.AdjancencyList.walk_tree(:dfs, list, nil, fn(x) -> x.name != "b" end) |> Enum.map(& &1.name)
    assert dfs == ["a", "c", "f", "g" ]
  end

  test "dfs with start node filterd", context do
    list = context[:tree_c]
    start = List.first(list)
    dfs = Trees.AdjancencyList.walk_tree(:dfs, list, start, fn(x) -> x.name != start.name end) |> Enum.map(& &1.name)
    assert dfs == []
  end

  test "can traverse children", context do
    list = context[:tree_a]
    root_node = List.first(list)
    children = Trees.AdjancencyList.descendants(root_node, list)
    assert children == Enum.slice(list, 1, 2)
  end

  test "can traverse parents", context do
    list = context[:tree_a]
    child_node = List.last(list)
    parents = Trees.AdjancencyList.ascendants(child_node, list)
    assert parents == Enum.slice(list, 0, 2) |> Enum.reverse
  end

  test "self and ascendants", context do
    list = context[:tree_a]
    child_node = List.last(list)
    parents = Trees.AdjancencyList.self_and_ascendants(child_node, list)
    assert parents == Enum.reverse(list)
  end

  test "can_handle multiple trees", context do
    list = context[:tree_a] ++ context[:tree_b]
    tree_b = context[:tree_b]
    root_node = List.first(context[:tree_b])
    children = Trees.AdjancencyList.descendants(root_node, list)
    assert children == [Enum.at(tree_b, 1)]
  end

  test "siblings of root node", context do
    list = context[:tree_a] ++ context[:tree_b]

    tree_a_root = List.first(context[:tree_a])
    tree_b_root = List.first(context[:tree_b])

    siblings = Trees.AdjancencyList.siblings(tree_a_root, list)
    assert siblings == [tree_b_root]
  end

  test "siblings of non-root node", context do
    list = context[:tree_a]
    node = Enum.at(list, 1)
    siblings = Trees.AdjancencyList.siblings(node, list)
    assert siblings == [List.last(list)]
  end

  test "tree level", context do
    list = context[:tree_a]
    node = Enum.at(list, 1)
    assert Trees.AdjancencyList.tree_level(node, list) == 1
  end

  test "generations", context do
    list = context[:tree_a]
    generations = Trees.AdjancencyList.generations(list)
    expected = %{0 => [Enum.at(list, 0)], 1 => [Enum.at(list, 1)], 2 => [Enum.at(list, 2)]}
    assert generations == expected
  end
end
