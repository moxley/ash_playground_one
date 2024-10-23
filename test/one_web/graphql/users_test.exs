defmodule OneWeb.Graphql.UsersTest do
  use OneWeb.ConnCase, async: true

  describe "signup_user" do
    @signup_user """
    mutation SignupUser($input: SignupUserInput!) {
      signupUser(input: $input) {
        result {
          id
          name
          email
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
      params = %{
        query: @signup_user,
        variables: %{
          input: %{"email" => "user@example.com"}
        }
      }

      resp =
        ctx.conn
        |> post("/gql", params)
        |> json_response(200)

      assert %{"data" => %{"signupUser" => %{"result" => _result}}} = resp

      # The following fails. Actual value is:
      # [%{"code" => "forbidden_field", "fields" => [], "locations" => [%{"column" => 7, "line" => 5}], "message" => "forbidden field", "path" => ["signupUser", "result", "name"], "short_message" => "forbidden field", "vars" => %{}}]
      #
      # Log:
      #       12:32:10.220 request_id=GADdQXXUF9hJtx4AAapF [warning] One.User.signup
      #
      # Policy Breakdown for selecting or loading fields fields: [:name]
      # unknown actor
      #
      #   Bypass: Policy | 🔎:
      #
      #     condition: always true
      #
      #     authorize if: id == {:_actor, :id} | ✘ | 🔎
      #
      # SAT Solver statement:
      #
      #  ("id == {:_actor, :id}" or "always false") and ("id == {:_actor, :id}" or "always false")
      # 12:32:10.223 request_id=GADdQXXUF9hJtx4AAapF [warning] One.User.read
      #
      # Policy Breakdown for selecting or loading fields fields: [:name, :email]
      # unknown actor
      #
      #   Bypass: Policy | 🔎:
      #
      #     condition: always true
      #
      #     authorize if: id == {:_actor, :id} | ✘ | 🔎
      #
      # SAT Solver statement:
      #
      #  ("id == {:_actor, :id}" or "always false") and ("id == {:_actor, :id}" or "always false")

      assert resp["errors"] == nil
    end
  end
end
