defmodule OneWeb.Graphql.RepresentativesTest do
  use OneWeb.ConnCase, async: true

  alias Helpdesk.Support.Representative

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
      assert %{"result" => result} = create_resp
      assert result["id"]
      assert result["name"] == "Jane Doe"
    end
  end

  describe "getRepresentativeSelf" do
    @get_representative_self """
    query GetRepresentativeSelf {
      getRepresentativeSelf {
        id
        name
      }
    }
    """

    test "when no auth token provided", ctx do
      Ash.create!(Representative, %{name: "Rep 1"}, authorize?: false)

      params = %{query: @get_representative_self}

      resp =
        ctx.conn
        |> post("/gql", params)
        |> json_response(200)

      assert %{"data" => %{"getRepresentativeSelf" => get_resp}} = resp
      assert get_resp == nil
    end
  end

  describe "updateRepresentativeSelf" do
    @update_representative_self """
    mutation UpdateRepresentativeSelf($input: UpdateRepresentativeSelfInput!) {
      updateRepresentativeSelf(input: $input) {
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

    test "when no actor present, should not update anything", ctx do
      representative1 = Ash.create!(Representative, %{name: "Rep 1"}, authorize?: false)
      representative2 = Ash.create!(Representative, %{name: "Rep 2"}, authorize?: false)

      input = %{name: "New Name"}
      params = %{query: @update_representative_self, variables: %{input: input}}

      resp =
        ctx.conn
        |> post("/gql", params)
        |> json_response(200)

      representative1 = One.Repo.get!(Representative, representative1.id)
      # Fails here: name is now "New Name"
      assert representative1.name == "Rep 1"
      representative2 = One.Repo.get!(Representative, representative2.id)
      assert representative2.name == "Rep 2"

      assert %{"data" => %{"updateRepresentativeSelf" => update_resp}} = resp
      assert update_resp["errors"] == []
      assert %{"result" => result} = update_resp
      # Fails here: result is not nil
      assert result == nil

      # In addition, Helpdesk.CurrentActorRead.read/4 was not called
    end
  end
end
