defmodule Test.Events do
  use Ecto.Schema
  import Ecto.Changeset
  @primary_key {:timestamp, :naive_datetime, []}
  @events_allowed ["push", "pop"]
  schema "events" do
      field :event, :string
      field :value, :integer
    end
  
  def changeset(events, params) do
    events
    |> cast(params, [:event, :value, :timestamp])
    |> validate_inclusion(:event, @events_allowed)
  end

  
end