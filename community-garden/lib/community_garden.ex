# Use the Plot struct as it is provided
defmodule Plot do
  @enforce_keys [:plot_id, :registered_to]
  defstruct [:plot_id, :registered_to]
end

defmodule CommunityGarden do
  def start(_opts \\ []) do
    Agent.start_link(fn -> %{plots: %{}, id: 1} end)
  end

  def list_registrations(pid) do
    Agent.get(pid, &Map.values(&1.plots))
  end

  def register(pid, register_to) do
    Agent.get_and_update(pid, fn db ->
      plot = create_plot(db.id, register_to)

      new_db =
        db
        |> put_in([:plots, db.id], plot)
        |> Map.put(:id, db.id + 1)

        {plot, new_db}
    end)
  end

  def release(pid, plot_id) do
    Agent.update(pid, &%{&1 | plots: Map.delete(&1.plots, plot_id)})
  end

  def get_registration(pid, plot_id) do
    Agent.get(pid, &Map.get(&1.plots, plot_id, {:not_found, "plot is unregistered"}))
  end

  defp create_plot(plot_id, register_to) do
    %Plot{plot_id: plot_id, registered_to: register_to}
  end
end
