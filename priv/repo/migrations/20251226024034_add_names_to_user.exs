defmodule Ers.Repo.Migrations.AddNamesToUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :firstname, :string
      add :lastname, :string
    end
  end
end
