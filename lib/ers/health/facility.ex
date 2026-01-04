defmodule Ers.Health.Facility do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "facilities" do
    field :name, :string
    field :state, :string
    field :address, :string
    field :facility_type, :string
    field :lga, :string
    field :phone, :string
    field :email, :string
    field :is_active, :boolean, default: true
    has_many :users, Ers.Accounts.User

    has_many :sent_referrals, Ers.Health.Referral,
      foreign_key: :referring_facility_id

    has_many :received_referrals, Ers.Health.Referral,
      foreign_key: :receiving_facility_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(facility, attrs) do
    facility
    |> cast(attrs, [:name, :facility_type, :address, :lga, :state, :phone, :email, :is_active])
    |> validate_required([:name, :facility_type, :lga, :state])
    |> validate_inclusion(:facility_type, ["PHC", "SHF"])
  end
end
