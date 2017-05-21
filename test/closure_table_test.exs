defmodule ClosureTableTest do
  use ExUnit.Case
  import Trees.ClosureTable

  setup do
    [
      tree_a: [
        %{id: 1, parent_id: nil, name: "a"},
        %{id: 2, parent_id: 1, name: "b"},
        %{id: 3, parent_id: 1, name: "c"},
        %{id: 4, parent_id: 2, name: "d"},
        %{id: 5, parent_id: 2, name: "e"},
        %{id: 6, parent_id: 3, name: "f"},
        %{id: 7, parent_id: 3, name: "g"},
        %{id: 8, parent_id: 5, name: "h"},
      ],
      tree_b: [
        %{id: 1, parent_id: nil, name: "a"},
        %{id: 2, parent_id: 1, name: "b"},
        %{id: 3, parent_id: 1, name: "c"},
        %{id: 4, parent_id: 2, name: "d"},
      ]
    ]
  end

  setup _context do
    :ok
  end

  test "closure table", context do
    tree = context[:tree_b]
    table = from_adjacency_list(tree) |> Enum.map(& [&1.ancestor.id, &1.descendant.id, &1.level])

    expected_table = [[1, 1, 0], [2, 2, 0], [3, 3, 0], [4, 4, 0], [1, 4, 2], [1, 3, 1], [1, 2, 1], [2, 4, 1]]
    assert table == expected_table
  end

  test "closure table traversal from root", context do
    table = context[:tree_a] |> from_adjacency_list
    # children of root
    children_of_root = table
                       |> Enum.filter(fn(x) -> x.level != 0 && x.ancestor.id == 1 end)
                       |> Enum.map(& &1.descendant.name)
                       |> Enum.reverse

   assert children_of_root == ["b", "c", "d", "e", "f", "g", "h"]
  end
end
