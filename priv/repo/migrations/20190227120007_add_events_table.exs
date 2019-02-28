defmodule Test.Repo.Migrations.AddEventsTable do
  use Ecto.Migration

  def up do
    create table("events", primary_key: false) do
      add :event, :string, size: 40
      add :value, :integer, null: true
      add :timestamp, :naive_datetime, null: false
      
    end
    execute("SELECT create_hypertable('events', 'timestamp')")
  end

  def down do
    drop table("events")
  end
end
