defmodule ExMonApiWeb.PokemonController do
  use ExMonApiWeb, :controller

  action_fallback ExMonApiWeb.FallbackController

  def show(conn, %{"name" => name}) do
    name
    |> ExMonApi.fetch_pokemon()
    |> handle_response(conn)
  end

  defp handle_response({:ok, pokemon}, conn) do
    conn
    |> put_status(:ok)
    |> json(pokemon) # The @derive used on the Pokemon struct allows this
  end
  defp handle_response({:error, _reason} = error, _conn), do: error
end
