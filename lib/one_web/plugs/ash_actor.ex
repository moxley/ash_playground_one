defmodule OneWeb.Plugs.AshActor do
  use Plug.Builder

  def init(opts), do: opts

  def call(conn, _opts) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
         {:ok, user, _claims} <- One.Guardian.resource_from_token(token) do
      conn
      |> Ash.PlugHelpers.set_actor(user)
    else
      _ -> conn
    end
  end
end
