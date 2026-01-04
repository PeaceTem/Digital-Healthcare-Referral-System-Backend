defmodule Ers.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :firstname, :string
    field :lastname, :string
    field :email, :string
    field :password, :string, virtual: true
    field :hashed_password, :string
    field :role, :string # "phc", "shf", "admin"
    belongs_to :facility, Ers.Health.Facility, type: :binary_id
    timestamps()
  end

  def registration_changeset(user, attrs) do
    user
    |> cast(attrs, [:firstname, :lastname, :email, :password, :role, :facility_id])
    |> validate_required([:firstname, :lastname, :email, :password, :role, :facility_id])
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 6)
    |> validate_inclusion(:role, ~w(PHC SHF ADMIN))
    |> unique_constraint(:email)
    |> assoc_constraint(:facility)
    |> put_password_hash()
  end

    def facility_changeset(user, attrs) do
    user
    |> cast(attrs, [:firstname, :lastname, :email, :password, :role, :facility_id])
    |> assoc_constraint(:facility)
  end

  defp put_password_hash(changeset) do
    if pw = get_change(changeset, :password) do
      change(changeset, hashed_password: Pbkdf2.hash_pwd_salt(pw))
    else
      changeset
    end
  end
end
