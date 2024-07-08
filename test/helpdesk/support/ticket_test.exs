defmodule Helpdesk.Support.TicketTest do
	use One.DataCase, async: true
	alias Helpdesk.Support.Ticket

  test "create" do
    ticket =
      Ticket
      |> Ash.Changeset.for_create(:create)
      |> Ash.create!()

    assert %Ticket{} = ticket
  end
end
