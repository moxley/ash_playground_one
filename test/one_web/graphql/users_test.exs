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

      assert resp["errors"] == nil
    end
  end

  describe "list_users" do
    @list_users """
    query ListUsers($filter: UserFilterInput) {
      listUsers(filter: $filter) {
        results {
          id
          name
          email
          isPublic
          status
        }
      }
    }
    """

    test "success", ctx do
      _user =
        One.User.create!(%{name: "User 1", email: "user@example.com", is_public: true},
          authorize?: false
        )

      params = %{
        query: @list_users,
        variables: %{
          filter: %{
            or: [
              %{status: %{eq: "ACTIVE"}},
              %{status: %{eq: "INACTIVE"}}
            ]
          }
        }
      }

      resp =
        ctx.conn
        |> post("/gql", params)
        |> json_response(200)

      dbg(resp)
      assert %{"data" => %{"listUsers" => %{"results" => _results}}} = resp

      assert resp["errors"] == nil
    end
  end
end
