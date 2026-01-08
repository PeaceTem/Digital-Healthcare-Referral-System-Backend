defmodule Ers.Repo.Migrations.AddReferral do
  use Ecto.Migration

  def change do
    create table(:referrals, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :status, :string, null: false
      add :patient_name, :string
      add :patient_gender, :string, null: false
      add :patient_age, :integer
      add :notes, :text

      add :referring_facility_id,
          references(:facilities, type: :binary_id),
          null: false

      add :receiving_facility_id,
          references(:facilities, type: :binary_id),
          null: false

      timestamps()
    end

    create index(:referrals, [:referring_facility_id])
    create index(:referrals, [:receiving_facility_id])

    create table(:messages, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :body, :text, null: false

      add :referral_id,
          references(:referrals, type: :binary_id, on_delete: :delete_all),
          null: false

      add :sender_id,
          references(:users, type: :integer),
          null: false

      timestamps()
    end

    create index(:messages, [:referral_id])
  end
end
