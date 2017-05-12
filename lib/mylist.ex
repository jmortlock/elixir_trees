defmodule MyList do
  # Takes 2 lists like [1,2] and [3,4]
  # and produces a single list like [1,3,2,4]
  def zip_merge([heada | taila], [headb | tailb]) do
    [heada] ++ [headb] ++ zip_merge(taila, tailb)
  end

  def zip_merge([heada | taila], []) do
    [heada] ++ zip_merge(taila, [])
  end

  def zip_merge([], [headb | tailb]) do
    [headb] ++ zip_merge([], tailb)
  end

  def zip_merge([], []) do
    []
  end
end
