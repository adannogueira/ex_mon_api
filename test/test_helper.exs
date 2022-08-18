ExUnit.start()
Code.require_file("test/mock_setup.exs")
Ecto.Adapters.SQL.Sandbox.mode(ExMonApi.Repo, :manual)
