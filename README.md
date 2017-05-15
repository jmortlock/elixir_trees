# Trees

**Trees.AdjacencyList**  
This is a implentation of an basic hireachical data structure you might see in an sql database,
backend is powered by a linked-list and all traversal functions happen on this list.  

This will obviously not be a very optimal solution, but fine when the data sets are small enough.

| Id            | ParentId      | Name  |
| ------------- |:-------------:| -----:|
| 0             | nil           | a     |
| 1             | 0             | b     |
| 2             | 1             | c     |


** Traversal **  
Basic algorithms to traverse the list are available including,
* Breadth-first_search (https://en.wikipedia.org/wiki/Breadth-first_search)
* Depth-first_search (https://en.wikipedia.org/wiki/Depth-first_search)

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `trees` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:trees, "~> 0.1.0"}]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/trees](https://hexdocs.pm/trees).
