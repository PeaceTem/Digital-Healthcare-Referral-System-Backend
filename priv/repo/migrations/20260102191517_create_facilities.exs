defmodule Ers.Repo.Migrations.CreateFacilities do
  use Ecto.Migration

  def change do
    create table(:facilities, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string, null: false
      add :facility_type, :string, null: false
      add :address, :string
      add :lga, :string
      add :state, :string
      add :phone, :string
      add :email, :string
      add :is_active, :boolean, default: true

      timestamps(type: :utc_datetime)
    end

    create index(:facilities, [:facility_type])
    create index(:facilities, [:lga])
  end
end
