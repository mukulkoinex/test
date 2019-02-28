defmodule Test.Queries do
  import Ecto.Query
  alias Test.Repo
  def get_events() do
    query = from e in "events", order_by: [asc: :timestamp], select: {e.event, e.value}
    Repo.all(query)
  end
end