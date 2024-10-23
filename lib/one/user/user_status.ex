defmodule One.User.UserStatus do
  use Ash.Type.Enum, values: [:non_member, :inactive, :active, :banned]

  def graphql_type(_), do: :user_status
  def graphql_input_type(_), do: :user_status
end
