defmodule Helpdesk.Support do
  use Ash.Domain, extensions: [
    AshGraphql.Domain
  ]

  resources do
    resource Helpdesk.Support.Note
    resource Helpdesk.Support.Representative
    resource Helpdesk.Support.Ticket
  end

  graphql do
    authorize? false # Defaults to `true`, use this to disable authorization for the entire domain (you probably only want this while prototyping)
  end
end
