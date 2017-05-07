defmodule TreesTest do
  use ExUnit.Case

  setup do
    [list: [
      %{:id => 0, :name => "parent", :parent_id => nil},
      %{:id => 1, :name => "child", :parent_id => 0},
      %{:id => 2, :name => "second child", :parent_id => 1},
    ]]
  end

  setup _context do
    :ok
  end

  test "can traverse children", context do
    list = context[:list]
    root_node = List.first(list)
    children = Trees.List.children_of_node(root_node, list)
    assert children == [Enum.at(list, 1)] ++ [Enum.at(list, 2)]
  end

  test "can traverse parents", context do
    list = context[:list]
    child_node = List.last(list)
    parents = Trees.List.parents_of_node(child_node, list)
    assert parents == [Enum.at(list, 1)] ++ [Enum.at(list, 0)]
  end
end
