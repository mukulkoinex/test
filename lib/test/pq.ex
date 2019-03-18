defmodule  Test.PQ do
  use GenServer
  alias Test.Queries
  alias Test.Events
  alias Test.Repo

  @moduledoc """
  This is a GenServer module which is functioning as an in memory priority queue. It receives messages for actions like
  push and pop.
  """

  def start_link(state) do
    GenServer.start_link(__MODULE__, state)
  end

  def init(state) do
    {:ok, state}
  end

  def handle_cast({:push, val}, state) do
    current_timestamp = Timex.now("Asia/Kolkata")
    changeset = Events.changeset(%Events{}, %{event: "push", value: val, timestamp: current_timestamp})
    with true <- changeset.valid? do
      insert_push_event(changeset)
      new_state = PriorityQueue.put(state, val)
      {:noreply, new_state}
    else
      false ->
        {:noreply, state}
    end
  end

  def handle_cast({:dbpush, val}, state) do
    new_state = PriorityQueue.put(state, val)
    {:noreply, new_state}
  end

  def handle_call({:pop}, _from, state) do
    current_timestamp = Timex.now("Asia/Kolkata")
    changeset = Events.changeset(%Events{}, %{event: "pop", value: nil, timestamp: current_timestamp})
    with true <- changeset.valid? do
      insert_pop_event(changeset)
      {val, new_state} = PriorityQueue.pop(state)
      {:reply, val, new_state}
    else
      false ->
        {:reply, :error, state}

    end
  end

  def handle_call({:dbpop}, _from, state) do
    {val, new_state} = PriorityQueue.pop(state)
    {:reply, val, new_state}
  end

  def handle_call({:peek}, _from, state) do
    {:reply, state, state}
  end

  def handle_info(_msg, state) do
    {:noreply, state}
  end
  def insert_push_event(changeset) do
    Task.start(fn -> Repo.insert(changeset) end)
  end

  def insert_pop_event(changeset) do
    Task.start(fn -> Repo.insert(changeset) end) # Starts a background process that inserts into db.
  end

  def insert() do
    Enum.each(1..100, fn _ ->
      a = :random.uniform(100)
      GenServer.cast(Test.PQ, {:push, a})
    end)
  end

end
