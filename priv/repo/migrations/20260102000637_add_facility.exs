defmodule Ers.Repo.Migrations.AddFacility do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :facility, :string, null: false, default: "Agbowo PHC"
    end
  end
end
