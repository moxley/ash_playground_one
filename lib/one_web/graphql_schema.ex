defmodule OneWeb.GraphqlSchema do
  use Absinthe.Schema
  use AshGraphql, domains: [Helpdesk.Support, One.Domain]

  # Example data
  @items %{
    "foo" => %{id: "foo", name: "Foo"},
    "bar" => %{id: "bar", name: "Bar"}
  }

  @desc "An item"
  object :item do
    field :id, :id
    field :name, :string
  end

  query do
    field :item, :item do
      arg(:id, non_null(:id))

      resolve(fn %{id: item_id}, _ ->
        {:ok, @items[item_id]}
      end)
    end
  end

  mutation do
  end
end
