defmodule Ers.Plugs.AuthPipeline do
  import Plug.Conn
  alias Ers.Auth

  def init(opts), do: opts

  def call(conn, _opts) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
        {:ok, claims} <- Auth.verify_token(token),
        _ <- IO.inspect(claims, label: "Verified Claims"),
        user <- Ers.Accounts.get_user_by_email(claims["email"])
        do
      assign(conn, :current_user, user)
    else
      _ ->
        conn
        |> send_resp(401, "Unauthorized")
        |> halt()
    end
  end
end
