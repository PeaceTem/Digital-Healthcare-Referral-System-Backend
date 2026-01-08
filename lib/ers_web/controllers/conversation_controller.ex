defmodule ErsWeb.ConversationController do
  use ErsWeb, :controller

  alias Ers.Health.Conversations

  def index(conn, _params) do
    user = conn.assigns.current_user

    data = Conversations.get_dashboard_data(user)

    json(conn, %{conversations: data})
  end
end
