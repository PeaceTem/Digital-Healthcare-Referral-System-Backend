defmodule Ers.Communication.Message do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "messages" do
    field :body, :string

    belongs_to :referral, Ers.Health.Referral
    belongs_to :sender, Ers.Accounts.User, type: :integer

    timestamps()
  end

  def changeset(message, attrs) do
    message
    |> cast(attrs, [:body, :referral_id, :sender_id])
    |> validate_required([:body, :referral_id, :sender_id])
    |> assoc_constraint(:referral)
    |> assoc_constraint(:sender)
  end
end
