defmodule Helpdesk.Support.Permissions do
  use Ash.Resource, data_layer: :embedded

  attributes do
    attribute :is_admin, :boolean, default: false, public?: true
  end
end
