defmodule One.User do
  use Ash.Resource,
    domain: One.Domain,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshGraphql.Resource],
    authorizers: [Ash.Policy.Authorizer]

  attributes do
    uuid_primary_key :id

    attribute :group_id, :uuid, public?: false
    attribute :name, :string, public?: true
    attribute :email, :string, public?: true

    create_timestamp :inserted_at
    update_timestamp :updated_at
  end

  identities do
    identity :users_unique_email, [:lower_email]
  end

  calculations do
    calculate :lower_email, :string, expr(string_downcase(email))
  end

  relationships do
    belongs_to :group, One.Group, public?: false
  end

  multitenancy do
    strategy :attribute
    attribute :group_id

    global? true
  end

  postgres do
    table "users"
    repo One.Repo

    migration_types email: :string

    unique_index_names [
      {[:email, :group_id], "custom_users_unique_email_index",
       "the email address is already being used in an existing account"}
    ]

    calculations_to_sql lower_email: "LOWER(email)"
  end

  actions do
    default_accept :*
    defaults [:read, :destroy]

    read :read_self do
      get? true
      manual One.CurrentActorRead
    end

    create :signup do
      upsert? true
      upsert_identity :users_unique_email
      accept [:name, :email]

      # change(&GF.Members.MemberActions.assign_id/2)
    end
  end

  policies do
    policy action [:signup] do
      authorize_if always()
    end
  end

  field_policies do
    field_policy_bypass [:email, :name] do
      authorize_if expr(id == ^actor(:id))
    end
  end

  graphql do
    type :user

    mutations do
      create :signup_user, :signup
    end
  end
end
