defmodule One.Domain do
  use Ash.Domain, extensions: [AshGraphql.Domain]

  resources do
    resource One.Group
    # resource One.User
  end
end
