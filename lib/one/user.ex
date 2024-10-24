defmodule One.User do
  use Ash.Resource,
    domain: One.Domain,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshGraphql.Resource],
    authorizers: [Ash.Policy.Authorizer]

  attributes do
    uuid_primary_key :id

    attribute :name, :string, public?: true
    attribute :email, :string, public?: true
    attribute :is_public, :boolean, public?: true
    attribute :status, One.User.UserStatus, default: :active, public?: true

    create_timestamp :inserted_at
    update_timestamp :updated_at
  end

  identities do
    identity :users_unique_email, [:email]
  end

  postgres do
    table "users"
    repo One.Repo

    migration_types email: :string

    unique_index_names [
      {[:email], "users_users_unique_email_index",
       "the email address is already being used in an existing account"}
    ]
  end

  actions do
    default_accept :*
    defaults [:create, :read, :destroy]

    read :read_self do
      get? true
      manual One.CurrentActorRead
    end

    create :signup do
      upsert? true
      upsert_identity :users_unique_email
      accept [:name, :email]
    end

    read :list do
      pagination offset?: true, default_limit: 50, max_page_size: 500, countable: true

      modify_query fn query, ecto_query ->
        dbg(query)
        {:ok, ecto_query}
      end
    end
  end

  policies do
    policy action [:signup] do
      authorize_if always()
    end

    policy action [:read] do
      authorize_if just_created_with_action(:signup)
    end

    policy action [:list] do
      authorize_if expr(is_public)
    end
  end

  field_policies do
    field_policy_bypass [:email, :name] do
      authorize_if expr(id == ^actor(:id))
      authorize_if just_created_with_action(:signup)
      authorize_if action(:signup)
    end

    field_policy [:email, :name, :is_public, :status] do
      authorize_if expr(is_public)
    end
  end

  graphql do
    type :user

    queries do
      list :list_users, :list do
        paginate_with :offset
      end
    end

    mutations do
      create :signup_user, :signup
    end
  end

  code_interface do
    define :get_by_id, action: :read, get_by: :id, not_found_error?: false
    define :create, action: :create
  end
end
