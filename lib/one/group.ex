defmodule One.Group do
  use Ash.Resource,
    domain: One.Domain,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshGraphql.Resource],
    authorizers: [Ash.Policy.Authorizer]

  attributes do
    uuid_primary_key :id

    attribute :name, :string, public?: true

    create_timestamp :inserted_at
    update_timestamp :updated_at
  end

  postgres do
    table "groups"
    repo One.Repo
  end

  actions do
    default_accept :*
    defaults [:create, :read, :update, :destroy]
  end

  code_interface do
    define :create_group, action: :create
  end

  graphql do
    type :group
  end
end
