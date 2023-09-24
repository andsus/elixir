defmodule Chessboard do
  def rank_range, do: 1..8

  def file_range, do: ?A..?H

  def ranks do
    rank_range()
    |> Enum.to_list()
  end

  def files do
    file_range()
    |> Enum.map(& (<<&1>>)) # Enum.map(fn f -> <<f>> end)
  end
end
