defmodule BinarySearch do
  @doc """
    Searches for a key in the tuple using the binary search algorithm.
    It returns :not_found if the key is not in the tuple.
    Otherwise returns {:ok, index}.

    ## Examples

      iex> BinarySearch.search({}, 2)
      :not_found

      iex> BinarySearch.search({1, 3, 5}, 2)
      :not_found

      iex> BinarySearch.search({1, 3, 5}, 5)
      {:ok, 2}

  """

  @spec search(tuple, integer) :: {:ok, integer} | :not_found
  def search(data, target) do
    search(data, target, 0, tuple_size(data) - 1)
  end

  defp search(_, _, low, high) when low > high do
    :not_found
  end

  defp search(data, target, low, high) do
    pivot = Integer.floor_div(low + high, 2)
    pivot_value = elem(data, pivot)

    cond do
      pivot_value == target -> {:ok, pivot}
      pivot_value > target -> search(data, target, low, pivot - 1)
      pivot_value < target -> search(data, target, pivot + 1, high)
    end
  end

end
