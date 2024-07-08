defmodule Helpdesk.Support do
  use Ash.Domain

  resources do
    resource Helpdesk.Support.Note
    resource Helpdesk.Support.Representative
    resource Helpdesk.Support.Ticket
  end
end
