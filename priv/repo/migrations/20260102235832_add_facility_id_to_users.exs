defmodule Ers.Repo.Migrations.AddFacilityIdToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :facility_id, references(:facilities, type: :uuid, on_delete: :nilify_all)
    end

    create index(:users, [:facility_id])
  end
end
