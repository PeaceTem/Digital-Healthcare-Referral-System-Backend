defmodule Ers.Health.Conversations do
  import Ecto.Query
  alias Ers.Repo

  alias Ers.Health.{Facility, Referral}
  alias Ers.Communication.Message
  @epoch ~N[1970-01-01 00:00:00]


    def fetch_phc_dashboard(phc_facility_id) do
        shfs =
            from(f in Facility,
            where: f.facility_type == "SHF"
            )
            |> Repo.all()

        referrals =
            from(r in Referral,
            where:
                r.referring_facility_id == ^phc_facility_id or
                r.receiving_facility_id == ^phc_facility_id,
            preload: [messages: ^from(m in Message, order_by: [desc: m.inserted_at])],
            order_by: [desc: r.inserted_at]
            )
            |> Repo.all()

        build_conversations(shfs, referrals, phc_facility_id)
    end

    
    def fetch_shf_dashboard(shf_facility_id) do
        shfs =
            from(f in Facility,
            where: f.facility_type == "PHC"
            )
            |> Repo.all()

        referrals =
            from(r in Referral,
            where:
                r.referring_facility_id == ^shf_facility_id or
                r.receiving_facility_id == ^shf_facility_id,
            preload: [:messages]
            )
            |> Repo.all()

        build_conversations(shfs, referrals, shf_facility_id)
    end

    defp build_conversations(facilities, referrals, current_facility_id) do
        Enum.map(facilities, fn facility ->
            facility_referrals =
            Enum.filter(referrals, fn r ->
                (r.referring_facility_id == current_facility_id and
                r.receiving_facility_id == facility.id) or
                (r.receiving_facility_id == current_facility_id and
                r.referring_facility_id == facility.id)
            end)

            %{
            facility: facility,
            referrals: facility_referrals
            }
        end)
    end

    def format_facility_conversations(data) do
        Enum.map(data, fn f ->
            %{
            facility_id: f.facility.id,
            facility_name: f.facility.name,
            facility_type: f.facility.facility_type,
            referrals:
                Enum.map(
                f.referrals,
                &format_referral/1
                )
            }
        end)
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
            messages: Enum.map(referral.messages, &format_message/1)
        }
    end

    defp format_message(message) do
        %{
            id: message.id,
            body: message.body,
            sender_id: message.sender_id,
            facility_id: Ers.Repo.get!(Ers.Accounts.User, message.sender_id).facility_id,
            inserted_at: message.inserted_at
        }
    end

    def get_dashboard_data(user) do
        case user.role do
            "PHC" ->
            user.facility_id
            |> fetch_phc_dashboard()
            |> format_facility_conversations()
            |> Enum.sort_by(
            &last_activity_at/1,
            {:desc, NaiveDateTime}
            )

            "SHF" ->
            user.facility_id
            |> fetch_shf_dashboard()
            |> format_facility_conversations()
            |> Enum.sort_by(
            fn convo -> last_activity_at(convo) end,
            {:desc, NaiveDateTime}
            )
            _ ->
            []
        end
    end

    defp last_activity_at(%{referrals: []}), do: @epoch

    defp last_activity_at(%{referrals: referrals}) do
        referrals
        |> Enum.map(&referral_activity_at/1)
        |> Enum.reject(&is_nil/1)
        |> Enum.max(NaiveDateTime, fn -> @epoch end)
    end

    defp referral_activity_at(referral) do
        cond do
            has_messages?(referral) ->
            referral.messages
            |> List.last()
            |> Map.get(:inserted_at)

            referral.inserted_at ->
            referral.inserted_at

            true ->
            @epoch
        end
    end

    defp has_messages?(%{messages: messages}) when is_list(messages) and messages != [],
        do: true

    defp has_messages?(_), do: false

end
