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

import Ecto.Query, warn: false
alias Ers.Repo
alias Ers.Health.Facility

phc =
  Repo.get_by!(Facility, name: "Mokola PHC")

shfs = Enum.take(
  Repo.all(
    from f in Facility,
      where: f.facility_type == "SHF"
    
  ),
  6
)

referrals =
  Enum.flat_map(shfs, fn shf ->
    [
      # PHC → SHF
      Repo.insert!(%Ers.Health.Referral{
        status: "pending",
        patient_name: "Linus Paul",
        patient_gender: "male",
        patient_age: 32,
        notes: "Initial referral",
        referring_facility_id: phc.id,
        receiving_facility_id: shf.id
      }),

      # SHF → PHC (feedback / reverse)
      Repo.insert!(%Ers.Health.Referral{
        status: "completed",
        patient_name: "Patricia Smith",
        patient_gender: "female",
        patient_age: 45,
        notes: "Returned for follow-up",
        referring_facility_id: shf.id,
        receiving_facility_id: phc.id
      })
    ]
  end)

phc_user =
  Repo.get_by!(Ers.Accounts.User,
    email: "testuser1@gmail.com"
  )

shf_users =
  Enum.map(shfs, fn shf ->
    Repo.insert!(%Ers.Accounts.User{
      firstname: "SHF",
      lastname: "User",
      email: "shf3_#{shf.id}@test.com",
      hashed_password: phc_user.hashed_password,
      role: "SHF",
      facility_id: shf.id
    })
  end)

Enum.each(referrals, fn referral ->
  sender =
    if referral.referring_facility_id == phc.id do
      phc_user
    else
      Enum.find(shf_users, &(&1.facility_id == referral.referring_facility_id))
    end

  Repo.insert!(%Ers.Communication.Message{
    body: "Patient has been diagnosed with condition X.",
    referral_id: referral.id,
    sender_id: sender.id
  })

  Repo.insert!(%Ers.Communication.Message{
    body: "Acknowledged. Preparing to receive the patient.",
    referral_id: referral.id,
    sender_id: phc_user.id
  })
end)

