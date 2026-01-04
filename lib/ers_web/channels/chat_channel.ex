defmodule ErsWeb.ChatChannel do
  use Phoenix.Channel

  @impl true
  def join("chat:" <> room_id, _payload, socket) do
    {:ok, assign(socket, :room_id, room_id)}
  end

  @impl true
  def handle_in("message:new", %{"body" => body}, socket) do
    user = socket.assigns.user

    broadcast!(socket, "message:new", %{
      body: body,
      sender_id: user.id,
      sender_name: user.name,
      inserted_at: DateTime.utc_now()
    })

    {:noreply, socket}
  end
end
