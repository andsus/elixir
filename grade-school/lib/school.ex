defmodule School do
  @moduledoc """
  Simulate students in a school.

  Each student is in a grade.
  """

  @doc """
  Add a student to a particular grade in school.
  """
  @spec add(map, String.t(), integer) :: map
  def add(db, name, grade) do
    case students_in_grade?(db, name) do
      true -> db
      _ -> db |> Map.update(grade, [name], fn students -> [name | students] end)
    end
  end

  @doc """
  Return the names of the students in a particular grade.
  """
  @spec grade(map, integer) :: [String.t()]
  def grade(db, grade) do
    db
    |> Map.get(grade, [])
  end

  @doc """
  Sorts the school by grade and name.
  """
  @spec sort(map) :: [{integer, [String.t()]}]
  def sort(db) do
    # Enum.map(db, fn {grade, students} -> {grade, Enum.sort(students)} end)
    db
    |> Enum.map(fn {grade, students} ->
      {grade, Enum.sort(students)}
    end)

  end

  defp students_in_grade?(db, name) do
    Map.values(db)|> List.flatten |> Enum.member?(name)
  end
end
