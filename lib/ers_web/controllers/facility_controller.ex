defmodule ErsWeb.FacilityController do
  use ErsWeb, :controller

  def get_facilities(conn, _params) do
    # facilit
    json(conn, %{facilities: Ers.Health.list_facilities()})
  end

  # fetch all the shf
  # fetch all the referrals grouped by shf
  # fetch all the messages attached to each referral
  
end