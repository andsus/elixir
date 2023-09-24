defmodule LanguageList do
  def new(), do: []

  # prepend
  def add(list, language), do: [language | list]

  def remove([ _| tail]), do: tail

  def first([ head | tail]), do: head

  def count(list), do: length(list)

  def functional_list?(list), do: "Elixir" in list

end
