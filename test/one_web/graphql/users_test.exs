defmodule OneWeb.Graphql.UsersTest do
  use OneWeb.ConnCase, async: true

  describe "signup_user" do
    @signup_user """
    mutation SignupUser($input: SignupUserInput!) {
      signupUser(input: $input) {
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

    test "success", ctx do
      group = One.Group.create_group!(%{name: "Test Group"}, authorize?: false)

      params = %{
        query: @signup_user,
        variables: %{
          input: %{"email" => "user@example.com"}
        }
      }

      resp =
        ctx.conn
        |> put_req_header("x-group-id", group.id)
        |> post("/gql", params)
        |> json_response(200)

      assert %{"data" => %{"signupUser" => %{"result" => _result}}} = resp

      # This fails. Actual value is:
      # [%{"code" => "forbidden_field", "fields" => [], "locations" => [%{"column" => 7, "line" => 5}], "message" => "forbidden field", "path" => ["signupUser", "result", "name"], "short_message" => "forbidden field", "vars" => %{}}]
      assert resp["errors"] == nil
    end
  end
end
