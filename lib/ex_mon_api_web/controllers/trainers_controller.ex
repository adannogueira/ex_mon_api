defmodule ExMonApiWeb.TrainersController do
  use ExMonApiWeb, :controller

  alias ExMonApiWeb.Auth.Guardian

  action_fallback ExMonApiWeb.FallbackController

  # The connection is always present
  def create(conn, params) do
    # Using with to chain function execution, left side is the expected result of right side
    # When the with case is not matched, it won't throw the error, it just gives it back to caller
    with {:ok, trainer} <- ExMonApi.create_trainer(params),
         {:ok, token, _claims} <- Guardian.encode_and_sign(trainer) do
           conn
           |> put_status(:created)
           |> render("create.json", %{trainer: trainer, token: token})
         end
  end

  # The ID is being sent thru params, so, it's a string
  def delete(conn, %{"id" => id}) do
    id
    |> ExMonApi.delete_trainer()
    |> handle_delete(conn)
  end

  def show(conn, %{"id" => id}) do
    id
    |> ExMonApi.fetch_trainer()
    |> handle_response(conn, "show.json", :ok) # the :ok atom in this context represents the http 200
  end

  def update(conn, params) do
    params
    |> ExMonApi.update_trainer()
    |> handle_response(conn, "update.json", :ok)
  end

  def sign_in(conn, params) do
    with {:ok, token} <- Guardian.authenticate(params) do
      conn
      |> put_status(:ok)
      |> render("sign_in.json", token: token)
    end
  end

  defp handle_response({:ok, trainer}, conn, view, status) do
    conn
    |> put_status(status)
    |> render(view, trainer: trainer) # We're rendering the view here
  end

  # By default, in Elixir we deal with error on a fallback controller, so, we just forward it here
  defp handle_response({:error, _changeset} = error, _conn, _view, _status), do: error

  defp handle_delete({:ok, _trainer}, conn) do
    conn
    |> put_status(:no_content)
    |> text("")
  end
  defp handle_delete({:error, _reason} = error, _conn), do: error
end
