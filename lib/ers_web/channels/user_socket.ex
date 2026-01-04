defmodule ErsWeb.UserSocket do
  use Phoenix.Socket

  alias Ers.Auth

  channel "chat:*", ErsWeb.ChatChannel

  @impl true
  def connect(%{"token" => token}, socket, _connect_info) do
    {:ok, claims} = Auth.verify_token(token)

    case Ers.Accounts.get_user_by_email(claims["email"]) do
      {:ok, user} ->
        {:ok, assign(socket, :user, user)}

      _ ->
        :error
    end
  end

  def id(_socket), do: nil
end
