defmodule ExMonApiWeb.FallbackController do
  use ExMonApiWeb, :controller

  def call(conn, {:error, %{status: 404, message: message}}) do
    conn
    |> put_status(:not_found)
    |> put_view(ExMonApiWeb.ErrorView)
    |> render("404.json", error: message)
  end

  def call(conn, {:error, %{status: 401, message: message}}) do
    conn
    |> put_status(:unauthorized)
    |> put_view(ExMonApiWeb.ErrorView)
    |> render("401.json", error: message)
  end

  def call(conn, {:error, result}) do
    conn
    |> put_status(:bad_request)
    |> put_view(ExMonApiWeb.ErrorView) # Since the view has a different name, we must tell the controller where to render
    |> render("400.json", result: result)
  end
end
