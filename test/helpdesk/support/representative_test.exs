defmodule Helpdesk.Support.RepresentativeTest do
  use One.DataCase, async: true

  require Ash.Query, as: Query

  alias Ash.Changeset
  alias Helpdesk.Support.Representative

  test "read and update Representative as self" do
    representative =
      Representative
      |> Changeset.for_create(:create, %{name: "Jane Doe"}, authorize?: false)
      |> Ash.create!()

    query =
      Representative
      |> Ash.Query.select([:name])
      |> Query.for_read(:read_self, %{}, actor: representative)

    _representative = Ash.read_one!(query)
  end

  test "update Representative as self" do
    representative =
      Representative
      |> Changeset.for_create(:create, %{name: "Jane Doe"}, authorize?: false)
      |> Ash.create!()

    representative =
      Representative
      |> Query.select([:name])
      |> Query.filter(id == ^representative.id)
      |> Query.for_read(:read, %{}, authorize?: false)
      |> Ash.read_one!()

    representative
    |> Changeset.for_update(:update_self, %{name: "New Name"}, actor: representative)
    |> Ash.update!(actor: representative)
  end
end
