defmodule Test.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  alias Test.Queries

  @doc """
  The start callback is called when the application starts.
  """
  def start(_type, _args) do
    # List all child processes to be supervised
    Node.connect(:"test2@Mukuls-MacBook-Pro")
    Node.connect(:"test1@Mukuls-MacBook-Pro")
    Node.connect(:"test3@Mukuls-MacBook-Pro")
    priority_queue = PriorityQueue.new()
    children = [
      # Start the Ecto repository
      Test.Repo,
      # Start the endpoint when the application starts
      TestWeb.Endpoint,
      {DynamicSupervisor, strategy: :one_for_one, name: Test.DynamicSupervisor}
      #Adding the Priority Queue genserver as a child to the supervisor. The Supervisor will restart if it crashes.
      # %{
      #   id: Test.PQ,
      #   start: {Test.PQ, :start_link, [priority_queue]}



      # }
      # Starts a worker by calling: Test.Worker.start_link(arg)
      # {Test.Worker, arg},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Test.Supervisor]
    temp = Supervisor.start_link(children, opts)

    # events = Queries.get_events()      # Fetching events from the databases.
    # Enum.each(events, fn event ->   #Rebuilding the priority queue
    #   case event do
    #     {"push", val} -> GenServer.cast(Test.PQ, {:dbpush, val})
    #     {"pop", _} -> GenServer.call(Test.PQ,{:dbpop})
    #   end

    # end)
    temp
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    TestWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
