defmodule ExMonApiWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common data structures and query the data layer.

  Finally, if the test case interacts with the database,
  we enable the SQL sandbox, so changes done to the database
  are reverted at the end of every test. If you are using
  PostgreSQL, you can even run database tests asynchronously
  by setting `use ExMonApiWeb.ConnCase, async: true`, although
  this option is not recommended for other databases.
  """

  use ExUnit.CaseTemplate
  import ExMonApiWeb.Auth.Guardian

  using do
    quote do
      # Import conveniences for testing with connections
      import Plug.Conn
      import Phoenix.ConnTest
      import ExMonApiWeb.ConnCase

      alias ExMonApiWeb.Router.Helpers, as: Routes

      # The default endpoint for testing
      @endpoint ExMonApiWeb.Endpoint
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(ExMonApi.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(ExMonApi.Repo, {:shared, self()})
    end

    params = %{name: "Adan", password: "12345678"}
    {:ok, trainer} = ExMonApi.create_trainer(params)
    {:ok, token, _claims} = encode_and_sign(trainer)

    conn = Plug.Conn.put_req_header(Phoenix.ConnTest.build_conn(), "authorization", "Bearer #{token}")
    {:ok, conn: conn}
  end
end
