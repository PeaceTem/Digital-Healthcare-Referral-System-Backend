defmodule Ers.Repo.Migrations.RemoveFacilityFromUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      remove :facility
    end
  end
end
