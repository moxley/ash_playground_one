defmodule Helpdesk.Support do
  use Ash.Domain,
    extensions: [
      AshGraphql.Domain
    ]

  require Ash.Query

  resources do
    resource Helpdesk.Support.Note
    resource Helpdesk.Support.Representative
    resource Helpdesk.Support.Ticket
  end

  graphql do
    # Defaults to `true`, use this to disable authorization for the entire domain (you probably only want this while prototyping)
    authorize? false
  end

  def get_representative_by_id(id) do
    Helpdesk.Support.Representative
    |> Ash.Query.filter(id == ^id)
    |> Ash.Query.limit(1)
    |> Ash.read_one!(authorize?: false)
  end
end
