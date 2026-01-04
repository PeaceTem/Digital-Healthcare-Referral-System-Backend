defmodule Ers.Accounts do
  alias Ers.Repo
  alias Ers.Accounts.User
  import Ecto.Query

  def list_users do
    Repo.all(User)
  end

  def get_user_by_email(email) do
    Repo.one(from u in User, where: u.email == ^email)
  end

  def authenticate_user(email, password) do
    case get_user_by_email(email) do
      nil ->
        {:error, :invalid_credentials}

      user ->
        if Pbkdf2.verify_pass(password, user.hashed_password) do
          {:ok, user}
        else
          {:error, :invalid_credentials}
        end
    end
  end

  def register_user(attrs) do
    %User{}
    |> User.registration_changeset(attrs)
    |> Repo.insert()
  end

  def fill_facility do
    users = list_users();

    users
    |> Enum.each(fn user -> user |> User.facility_changeset(%{facility_id: "859d4736-eb01-457e-890c-a6a6017faf20"}) |> Repo.update() end)
  end
end
