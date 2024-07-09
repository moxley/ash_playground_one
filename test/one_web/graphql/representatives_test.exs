defmodule OneWeb.Graphql.RepresentativesTest do
  use OneWeb.ConnCase, async: true

  test "simple request", ctx do
    query = """
    query GetItem($id: ID!) {
      item(id: $id) {
        id
        name
      }
    }
    """

    params = %{query: query, variables: %{id: Ecto.UUID.generate()}}

    resp =
      ctx.conn
      |> post("/gql", params)
      |> json_response(200)

    assert %{"data" => %{"item" => nil}} = resp
  end

  describe "create_representative" do
    @create_representative """
    mutation CreateRepresentative($input: CreateRepresentativeInput!) {
      createRepresentative(input: $input) {
        result {
          id
          name
        }
        errors {
          code
          fields
          message
          shortMessage
          vars
        }
      }
    }
    """

    test "create representative", ctx do
      input = %{name: "Jane Doe"}
      params = %{query: @create_representative, variables: %{input: input}}

      resp =
        ctx.conn
        |> post("/gql", params)
        |> json_response(200)

      assert %{"data" => %{"createRepresentative" => create_resp}} = resp

      dbg(create_resp)
    end
  end
end
