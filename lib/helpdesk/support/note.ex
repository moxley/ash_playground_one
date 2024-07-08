defmodule Helpdesk.Support.Note do
  # This turns this module into a resource
  use Ash.Resource, domain: Helpdesk.Support, data_layer: AshPostgres.DataLayer

  alias Helpdesk.Support.Representative

  actions do
    defaults [:create, :read]
  end

  attributes do
    uuid_primary_key :id

    attribute :body, :string
    attribute :representative_id, :uuid
  end

  relationships do
    belongs_to :representative, Representative
  end

  postgres do
    table "notes"
    repo One.Repo
  end
end
