defmodule ErsWeb.AuthController do
  use ErsWeb, :controller
  alias Ers.Accounts
  alias Ers.Auth

  def login(conn, %{"email" => email, "password" => password}) do
    case Accounts.authenticate_user(email, password) do
      {:ok, user} ->
        token= Auth.generate_token(user)
        IO.inspect(Auth.generate_token(user), label: "Generated Token")

        json(conn, %{
          token: token,
          user: %{
            id: user.id,
            email: user.email,
            role: user.role,
            facility_id: user.facility_id
          }
        })

      {:error, :invalid_credentials} ->
        conn
        |> put_status(401)
        |> json(%{error: "Invalid email or password"})
    end
  end

  def register(conn, %{"firstname" => firstname, "lastname" => lastname, "email" => email, "password" => password, "role" => role, "facilityId" => facility_id}) do
    # IO.puts "Registering user with email: #{email}, role: #{role}"
    case Accounts.register_user(%{
          firstname: firstname,
          lastname: lastname,
          email: email,
          password: password,
          role: role,
          facility_id: facility_id
        }) do
      {:ok, user} ->
        # IO.puts "User registered successfully: #{user.email}"
        
        # token = Auth.generate_token(user)


        conn
        |> put_status(:created)
        |> json(%{
          user: %{
            email: user.email,
            role: user.role
          }
        })

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{
          error: "Registration failed",
          details: Ecto.Changeset.traverse_errors(changeset, &translate_error/1)
        })
    end
  end

  defp translate_error({msg, opts}) do
    Enum.reduce(opts, msg, fn {key, value}, acc ->
      String.replace(acc, "%{#{key}}", to_string(value))
    end)
  end
end
