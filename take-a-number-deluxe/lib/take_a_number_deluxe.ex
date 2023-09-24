defmodule TakeANumberDeluxe do
  use GenServer

  # Client API

  @spec start_link(keyword()) :: {:ok, pid()} | {:error, atom()}
  def start_link(init_arg) do
    GenServer.start_link(__MODULE__, init_arg)
  end

  @spec report_state(pid()) :: TakeANumberDeluxe.State.t()
  def report_state(machine) do
    GenServer.call(machine, :report_state)
  end


  @spec queue_new_number(pid()) :: {:ok, integer()} | {:error, atom()}
  def queue_new_number(machine) do
    GenServer.call(machine, :queue_new_number)
  end

  @spec serve_next_queued_number(pid(), integer() | nil) :: {:ok, integer()} | {:error, atom()}
  def serve_next_queued_number(machine, priority_number \\ nil) do
    GenServer.call(machine, {:serve_next_queued_number, priority_number})
  end


  @spec reset_state(pid()) :: :ok
  def reset_state(machine) do
    GenServer.cast(machine, :reset_state)
  end

  # Server callbacks

  @impl GenServer
  def init(init_arg) do
    case TakeANumberDeluxe.State.new(
      init_arg[:min_number],
      init_arg[:max_number],
      Keyword.get(init_arg, :auto_shutdown_timeout, :infinity)
    ) do
      {:ok, state} -> {:ok, state, state.auto_shutdown_timeout}
      {_, reason} -> {:stop, reason}
    end
  end

  @impl GenServer
  def handle_call(:report_state, _from, state) do
    do_reply(state, state)
  end

  @impl GenServer
  def handle_call(:queue_new_number, _from, state) do
    TakeANumberDeluxe.State.queue_new_number(state)
    |> reply(state)
  end

  @impl GenServer
  def handle_call({:serve_next_queued_number, priority_number}, _from, state) do
    TakeANumberDeluxe.State.serve_next_queued_number(state, priority_number)
    |> reply(state)
  end

  @impl GenServer
  def handle_cast(:reset_state, state) do
    TakeANumberDeluxe.State.new(
      state.min_number,
      state.max_number,
      state.auto_shutdown_timeout
    )
    |> no_reply()
  end

  @impl GenServer
  def handle_info(message, state) do
    case message do
      :timeout -> {:stop, :normal, state}
      _ -> no_reply(state)
    end
  end

  defp reply({:ok, result, new_state}, _state), do: do_reply({:ok, result}, new_state)
  defp reply(error, state), do: do_reply(error, state)
  defp do_reply(message, state) do
    {:reply, message, state, state.auto_shutdown_timeout}
  end

  defp no_reply({:ok, state}), do: no_reply(state)
  defp no_reply(state), do: {:noreply, state, state.auto_shutdown_timeout}
end
