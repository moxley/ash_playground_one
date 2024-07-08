defmodule Helpdesk.Support.Representative do
  # This turns this module into a resource
  use Ash.Resource, domain: Helpdesk.Support, data_layer: AshPostgres.DataLayer

  actions do
    defaults [:create, :read]
  end

  attributes do
    uuid_primary_key :id

    attribute :name, :string
  end

  postgres do
    table "representatives"
    repo One.Repo
  end
end
