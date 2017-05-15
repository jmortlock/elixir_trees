defmodule TreesTest do
  use ExUnit.Case
  import Trees.AdjacencyList

  setup do
    [
      tree_a: [
        %{id: 0, parent_id: nil},
        %{id: 1, parent_id: 0},
        %{id: 2, parent_id: 1},
      ],
      tree_b: [
        %{id: 3, parent_id: nil},
        %{id: 4, parent_id: 3}
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
    tree = context[:tree_c]
    start = Enum.at(tree, 2)
    dfs = walk_tree(:dfs, tree, start) |> Enum.map(& &1.name)
    assert dfs == ["c", "f", "g"]
  end

  test "dfs from start", context do
    dfs = context[:tree_c] |> walk_tree |> Enum.map(& &1.name)
    assert dfs == ["a", "b", "d", "e", "h", "c", "f", "g"]
  end

  test "bfs", context do
    tree = context[:tree_c]
    bfs = walk_tree(:bfs, tree) |> Enum.map(& &1.name)
    assert bfs == ["a", "b", "c", "d", "e", "f", "g", "h"]
  end

  test "bfs with filter", context do
    tree = context[:tree_c]
    bfs = walk_tree(:bfs, tree, nil, fn(x) -> x.name == "a" end) |> Enum.map(& &1.name)
    assert bfs == ["a"]
  end

  test "dfs with filter", context do
    tree = context[:tree_c]
    dfs = walk_tree(:dfs, tree, nil, fn(x) -> x.name != "b" end) |> Enum.map(& &1.name)
    assert dfs == ["a", "c", "f", "g" ]
  end

  test "dfs with start node filterd", context do
    tree = context[:tree_c]
    start = List.first(tree)
    dfs = walk_tree(:dfs, tree, start, fn(x) -> x.name != start.name end) |> Enum.map(& &1.name)
    assert dfs == []
  end

  test "can traverse descendants", context do
    tree = context[:tree_a]
    children = tree |> List.first |> descendants(tree)
    assert children == Enum.slice(tree, 1, 2)
  end

  test "can traverse ascendants", context do
    tree = context[:tree_a]
    parents = tree |> List.last |> ascendants(tree)
    assert parents == Enum.slice(tree, 0, 2) |> Enum.reverse
  end

  test "self and ascendants", context do
    tree = context[:tree_a]
    parents = tree |> List.last |> self_and_ascendants(tree)
    assert parents == Enum.reverse(tree)
  end

  test "can_handle multiple trees", context do
    tree = context[:tree_a] ++ context[:tree_b]
    tree_b = context[:tree_b]
    children = tree_b |> List.first |> descendants(tree)
    assert children == [Enum.at(tree_b, 1)]
  end

  test "roots", context do
    tree = context[:tree_a] ++ context[:tree_b]
    roots = [List.first(context[:tree_a])] ++ [List.first(context[:tree_b])]
    assert roots(tree) == roots
  end

  test "root?", context do
    tree = context[:tree_b]
    assert tree |> List.first |> root? == true
    assert tree |> List.last |> root? == false
  end

  test "leaf?", context do
    tree = context[:tree_b]
    assert tree |> List.first |> leaf?(tree) == false
    assert tree |> List.last |> leaf?(tree) == true
  end

  test "siblings of root node", context do
    tree = context[:tree_a] ++ context[:tree_b]

    tree_a_root = context[:tree_a] |> List.first
    tree_b_root = context[:tree_b] |> List.first

    siblings = siblings(tree_a_root, tree)
    assert siblings == [tree_b_root]
  end

  test "siblings of non-root node", context do
    tree = context[:tree_a]
    siblings = tree |> Enum.at(1) |> siblings(tree)
    assert siblings == [List.last(tree)]
  end

  test "tree level", context do
    tree = context[:tree_a]
    assert tree |> Enum.at(1) |> tree_level(tree) == 1
  end

  test "generations", context do
    tree = context[:tree_a]
    generations = generations(tree)
    expected = %{0 => [Enum.at(tree, 0)], 1 => [Enum.at(tree, 1)], 2 => [Enum.at(tree, 2)]}
    assert generations == expected
  end
end
