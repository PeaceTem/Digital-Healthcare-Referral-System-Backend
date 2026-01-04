# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Ers.Repo.insert!(%Ers.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Ers.Repo
alias Ers.Health.Facility

facilities = [
  # PHCs
    %{name: "Agodi PHC", facility_type: "PHC", lga: "Ibadan North", state: "Oyo"},
    %{name: "Bodija PHC", facility_type: "PHC", lga: "Ibadan North", state: "Oyo"},
    %{name: "Oke-Are PHC", facility_type: "PHC", lga: "Ibadan North", state: "Oyo"},
    %{name: "Yemetu PHC", facility_type: "PHC", lga: "Ibadan North", state: "Oyo"},
    %{name: "Sango PHC", facility_type: "PHC", lga: "Ibadan North", state: "Oyo"},    
    %{name: "Agbowo PHC", facility_type: "PHC", lga: "Ibadan North", state: "Oyo"},
    %{name: "Orogun PHC", facility_type: "PHC", lga: "Ibadan North", state: "Oyo"},
    %{name: "Samonda PHC", facility_type: "PHC", lga: "Ibadan North", state: "Oyo"},
    %{name: "Mokola PHC", facility_type: "PHC", lga: "Ibadan North", state: "Oyo"},
    %{name: "Ashokun PHC", facility_type: "PHC", lga: "Ibadan North", state: "Oyo"},
    %{name: "Oke-Aremo PHC", facility_type: "PHC", lga: "Ibadan North", state: "Oyo"},
    %{name: "Ago-Tapa PHC", facility_type: "PHC", lga: "Ibadan North", state: "Oyo"},
    %{name: "Oja-Oba PHC", facility_type: "PHC", lga: "Ibadan North", state: "Oyo"},
    %{name: "Bashorun PHC", facility_type: "PHC", lga: "Ibadan North", state: "Oyo"},
    %{name: "New-Bodija PHC", facility_type: "PHC", lga: "Ibadan North", state: "Oyo"},
  # SHFs
    %{name: "University College Hospital (UCH)", facility_type: "SHF", lga: "Ibadan North", state: "Oyo"},
    %{name: "Adeoyo Maternity Teaching Hospital", facility_type: "SHF", lga: "Ibadan South West", state: "Oyo"},
    %{name: "Jericho Specialist Hospital", facility_type: "SHF", lga: "Ibadan North", state: "Oyo"},
    %{name: "Ring Road State Hospital", facility_type: "SHF", lga: "Ibadan South East", state: "Oyo"},
    %{name: "Oluyoro Catholic Hospital", facility_type: "SHF", lga: "Ibadan North", state: "Oyo"},
    %{name: "Our Lady of Apostles Hospital", facility_type: "SHF", lga: "Ibadan North East", state: "Oyo"},
    %{name: "Bola Tinubu Medical Centre", facility_type: "SHF", lga: "Ibadan North", state: "Oyo"},
    %{name: "LAUTECH Teaching Hospital, Ogbomoso (Referral)", facility_type: "SHF", lga: "Ogbomoso North", state: "Oyo"},
    %{name: "State Hospital Oyo", facility_type: "SHF", lga: "Oyo East", state: "Oyo"},
    %{name: "General Hospital Moniya", facility_type: "SHF", lga: "Akinyele", state: "Oyo"}
]

Enum.each(facilities, fn facility ->
  %Facility{}
  |> Facility.changeset(facility)
  |> Repo.insert!(on_conflict: :nothing)
end)
