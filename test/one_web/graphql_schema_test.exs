defmodule OneWeb.GraphqlSchemaTest do
  use ExUnit.Case

  test "item" do
    result =
      """
      {
        item(id: "foo") {
          name
        }
      }
      """
      |> Absinthe.run(OneWeb.GraphqlSchema)

    assert {:ok, %{data: %{"item" => %{"name" => "Foo"}}}} = result
  end
end
