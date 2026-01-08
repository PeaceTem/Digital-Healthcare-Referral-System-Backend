defmodule Ers.Health do
  alias Ers.Repo
  alias Ers.Health.Facility
  import Ecto.Query

  def list_facilities do
    Repo.all(from f in Facility, select: %{id: f.id, name: f.name, type: f.facility_type, lga: f.lga})
  end

  def create_referral(attrs) do
    %Ers.Health.Referral{}
    |> Ers.Health.Referral.changeset(attrs)
    |> Repo.insert()
  end
end
