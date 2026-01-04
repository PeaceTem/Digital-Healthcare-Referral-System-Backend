defmodule Ers.Health.Referral do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "referrals" do
    field :status, :string # pending | accepted | rejected | completed
    field :patient_name, :string
    field :patient_gender, :string # male | female | other
    field :patient_age, :integer
    field :notes, :string

    belongs_to :referring_facility, Ers.Health.Facility
    belongs_to :receiving_facility, Ers.Health.Facility

    has_many :messages, Ers.Communication.Message

    timestamps()
  end

  def changeset(referral, attrs) do
    referral
    |> cast(attrs, [
      :status,
      :patient_name,
      :notes,
      :referring_facility_id,
      :receiving_facility_id
    ])
    |> validate_required([
      :status,
      :referring_facility_id,
      :receiving_facility_id
    ])
    |> assoc_constraint(:referring_facility)
    |> assoc_constraint(:receiving_facility)
  end
end
