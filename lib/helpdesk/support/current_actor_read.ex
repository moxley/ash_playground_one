defmodule Helpdesk.CurrentActorRead do
  use Ash.Resource.ManualRead

  @impl true
  def read(_ash_query, _ecto_query, _opts, %{actor: actor} = _context) when not is_nil(actor) do
    dbg(actor)
    {:ok, [actor]}
  end

  def read(_, _, _, _) do
    dbg("read fallback")
    {:ok, []}
  end
end
