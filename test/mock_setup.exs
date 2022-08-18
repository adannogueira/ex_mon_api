defmodule MockSetup do
  import Tesla.Mock

  @base_url "https://pokeapi.co/api/v2/pokemon/"

  @body %{
    "id" => "any_id",
    "name" => "pikachu",
    "weight" => 60,
    "types" => [%{"slot" => 1, "type" => %{"name" => "electric"}}]
  }

  def mock_success(pokemon) do
    mock(fn %{method: :get, url: @base_url <> ^pokemon} ->
      %Tesla.Env{status: 200, body: @body}
    end)
  end

  def mock_failure(pokemon) do
    mock(fn %{method: :get, url: @base_url <> ^pokemon} ->
      %Tesla.Env{status: 404}
    end)
  end
end
