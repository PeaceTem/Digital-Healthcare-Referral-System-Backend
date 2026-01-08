defmodule Ers.Communication do
  alias Ers.Repo
  alias Ers.Communication.Message
  import Ecto.Query

  def create_message(attrs) do
    %Message{}
    |> Message.changeset(attrs)
    |> Repo.insert()
    end
end
