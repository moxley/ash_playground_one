defmodule Helpdesk.Support.Representative do
  # This turns this module into a resource
  use Ash.Resource,
    domain: Helpdesk.Support,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshGraphql.Resource],
    authorizers: [Ash.Policy.Authorizer]

  alias Helpdesk.CurrentActorRead

  actions do
    default_accept :*
    defaults [:create, :update, :destroy, :read]

    update :update_self do
    end

    read :current_actor do
      get? true

      manual CurrentActorRead
    end
  end

  attributes do
    uuid_primary_key :id

    attribute :name, :string, public?: true
    attribute :permissions, Helpdesk.Support.Permissions, public?: true
    attribute :is_admin, :boolean, public?: true
  end

  policies do
    policy action [:read] do
      authorize_if(always())
    end

    policy action [:create, :update, :destroy] do
      authorize_if actor_attribute_equals(:is_admin, true)
    end

    policy action [:read_self, :update_self] do
      authorize_if actor_attribute_equals(:__struct__, __MODULE__)
    end
  end

  field_policies do
    field_policy [:is_admin, :name, :permissions] do
      authorize_if actor_attribute_equals(:__struct__, UserModuleDoesNotExist)
    end

    field_policy [:name] do
      authorize_if actor_attribute_equals(:__struct__, __MODULE__)
    end
  end

  postgres do
    table "representatives"
    repo One.Repo
  end

  graphql do
    type :representative

    queries do
      get :get_representative, :read

      get :get_representative_self, :current_actor do
        identity false
      end

      list :list_representatives, :read
    end

    mutations do
      create :create_representative, :create
      update :update_representative, :update

      update :update_representative_self, :update_self do
        identity false
        read_action :current_actor
      end

      destroy :destroy_representative, :destroy
    end
  end
end
