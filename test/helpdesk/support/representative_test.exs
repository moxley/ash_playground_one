defmodule Helpdesk.Support.RepresentativeTest do
  use One.DataCase, async: true

  require Ash.Query, as: Query

  alias Ash.Changeset
  alias Helpdesk.Support.Representative

  test "read_self" do
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

  test "update_self" do
    representative =
      Representative
      |> Ash.Changeset.for_create(:create, %{name: "Jane Doe"}, authorize?: false)
      |> Ash.create!()

    representative =
      Representative
      |> Ash.Query.select([:name])
      |> Ash.Query.filter(id == ^representative.id)
      |> Ash.Query.for_read(:read, %{}, authorize?: false)
      |> Ash.read_one!()

    representative
    |> Ash.Changeset.for_update(:update_self, %{name: "New Name"}, actor: representative)
    |> Ash.update!(actor: representative)
  end

  test ":update as admin" do
    representative =
      Representative
      |> Ash.Changeset.for_create(:create, %{name: "Jane Doe"}, authorize?: false)
      |> Ash.create!()

    representative =
      Representative
      |> Ash.Query.select([:name])
      |> Ash.Query.filter(id == ^representative.id)
      |> Ash.Query.for_read(:read, %{}, authorize?: false)
      |> Ash.read_one!()

    actor_representative =
      Representative
      |> Ash.Changeset.for_create(:create, %{name: "Admin Rep", is_admin: true},
        authorize?: false
      )
      |> Ash.create!()

    representative
    |> Ash.Changeset.for_update(:update, %{name: "New Name"}, actor: actor_representative)
    |> Ash.update!(actor: actor_representative)
  end
end
