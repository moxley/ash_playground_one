defmodule Helpdesk.Support.Representative do
  # This turns this module into a resource
  use Ash.Resource,
    domain: Helpdesk.Support,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshGraphql.Resource]

  actions do
    defaults [:create, :update, :destroy, :read]
  end

  attributes do
    uuid_primary_key :id

    attribute :name, :string
  end

  postgres do
    table "representatives"
    repo One.Repo
  end

  graphql do
    type :representative

    queries do
      get :get_representative, :read
      list :list_representatives, :read
    end

    mutations do
      create :create_representative, :create
      update :update_representative, :update
      destroy :destroy_representative, :destroy
    end
  end
end
