defmodule OneWeb.Plugs.PutGroup do
  use Plug.Builder

  def init(opts), do: opts

  def call(conn, _opts) do
    with [group_id] <- get_req_header(conn, "x-group-id"),
         {:ok, group} <- One.Group.get_by_id(group_id, authorize?: false) do
      dbg(group)

      conn
      |> Ash.PlugHelpers.set_tenant(group.id)
      |> Ash.PlugHelpers.set_context(%{group: group})
    else
      _ -> conn
    end
  end
end
