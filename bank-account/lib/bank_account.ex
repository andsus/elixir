defmodule BankAccount do
  use GenServer
  @moduledoc """
  A bank account that supports access from multiple processes.
  """

  @typedoc """
  An account handle.
  """
  @opaque account :: pid

  @doc """
  Open the bank. Makes the account available.
  """
  @spec open_bank() :: account
  def open_bank() do
    # instantiate account with zero balance
    # {:ok, state}
    {:ok, account} = GenServer.start_link(__MODULE__, 0)
    account
  end

  @doc """
  Close the bank. Makes the account unavailable.
  """
  @spec close_bank(account) :: none
  def close_bank(account) do
    GenServer.stop(account, :normal, :infinity)
  end

  @doc """
  Get the account's balance.
  """
  @spec balance(account) :: integer
  def balance(account) do
    if Process.alive?(account) do
      GenServer.call(account, :balance)
    else
      {:error, :account_closed}
    end
  end

  @doc """
  Update the account's balance by adding the given amount which may be negative.
  """
  @spec update(account, integer) :: any
  def update(account, amount) do
    if Process.alive?(account) do
      GenServer.cast(account, amount)
    else
      {:error, :account_closed}
    end
  end



  @doc """
  Account close state
  """
  # defp account_closed(account) do
  #   case Process.alive?(account) do
  #     true -> :ok
  #     _ -> {:error, :account_closed}
  #   end
  # end

  # Server
  @impl GenServer
  def init(account) do
    {:ok, account}
  end

  @impl GenServer
  def handle_call(:balance, _from, account) do
    {:reply, account, account}
  end

  @impl GenServer
  def handle_cast(account, amount) do
    {:noreply, account + amount}
  end

  @impl GenServer
  def terminate(_reason, _account) do
    {:stop, :account_closed}
  end
end
