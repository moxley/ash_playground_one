defmodule One.CurrentActorRead do
  use Ash.Resource.ManualRead

  @impl true
  def read(_ash_query, _ecto_query, _opts, %{actor: actor} = _context) when not is_nil(actor) do
    {:ok, [actor]}
  end

  def read(_, _, _, _) do
    {:ok, []}
  end
end
