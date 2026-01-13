defmodule ErsWeb.ChatChannel do
  use Phoenix.Channel

  @impl true
  def join("chat:" <> room_id, _payload, socket) do
    {:ok, assign(socket, :room_id, room_id)}
  end

  # @impl true
  # def handle_in("conversations:fetch", _payload, socket) do
  #   user = socket.assigns.user

  #   data = Ers.Health.Conversations.get_dashboard_data(user)
  #   conversations = %{conversations: data}
  #   {:reply, {:ok, conversations}, socket}
  # end

  @impl true
  def handle_in("referral:create", payload, socket) do
    user = socket.assigns.user

    attrs = %{
      status: payload["status"],
      patient_name: payload["patient_name"],
      patient_gender: payload["patient_gender"],
      patient_age: payload["patient_age"],
      notes: payload["notes"],
      referring_facility_id: payload["referring_facility_id"],
      receiving_facility_id: payload["receiving_facility_id"],
    }

    case Ers.Health.create_referral(attrs) do
      {:ok, referral} ->
        ErsWeb.Endpoint.broadcast!("chat:#{referral.referring_facility_id}", "referral:created", format_referral(referral))
        ErsWeb.Endpoint.broadcast!("chat:#{referral.receiving_facility_id}", "referral:created", format_referral(referral))

        {:noreply, socket}  

      {:error, changeset} ->
        {:reply, {:error, %{errors: changeset.errors}}, socket}
    end
  end

  def handle_in("message:create", %{"body" => body, "referral_id" => referral_id, "receiving_facility_id" => receiving_facility_id}, socket) do
    user = socket.assigns.user

    attrs = %{
      body: body,
      referral_id: referral_id,
      sender_id: user.id
    }

    case Ers.Communication.create_message(attrs) do
      {:ok, message} ->

        ErsWeb.Endpoint.broadcast!("chat:#{user.facility_id}", "message:created", format_message(message, user.facility_id, receiving_facility_id))
        ErsWeb.Endpoint.broadcast!("chat:#{receiving_facility_id}", "message:created", format_message(message, user.facility_id, receiving_facility_id))

        {:noreply, socket}

      {:error, _changeset} ->
        {:reply, {:error, %{reason: "failed"}}, socket}
    end
  end

  # @impl true
  # def handle_in("conversations:testing", _payload, socket) do
  #   user = socket.assigns.user

  #   {:reply, {:ok, "Working like Kilishi!"}, socket}
  # end

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

  # =========================
  # NEW REFERRAL
  # =========================
  @impl true
  def handle_in("referral:new", referral_params, socket) do
    user = socket.assigns.user

    {:ok, referral} =
      Referrals.create_referral(
        Map.put(referral_params, "created_by_id", user.id)
      )

    broadcast!(socket, "referral:created", %{
      id: referral.id,
      patient_name: referral.patient_name,
      from_facility_id: referral.from_facility_id,
      to_facility_id: referral.to_facility_id,
      status: referral.status
    })

    {:noreply, socket}
  end

  defp format_referral(referral) do
      %{
          id: referral.id,
          status: referral.status,
          patient_name: referral.patient_name,
          patient_age: referral.patient_age,
          patient_gender: referral.patient_gender,
          notes: referral.notes,
          inserted_at: referral.inserted_at,
          referring_facility_id: referral.referring_facility_id,
          receiving_facility_id: referral.receiving_facility_id,
          messages: []
      }
  end

  defp format_message(message, referring_facility_id, receiving_facility_id) do
      %{
          id: message.id,
          body: message.body,
          sender_id: message.sender_id,
          referral_id: message.referral_id,
          inserted_at: message.inserted_at,
          referring_facility_id: referring_facility_id,
          receiving_facility_id: receiving_facility_id,
      }
  end
end
