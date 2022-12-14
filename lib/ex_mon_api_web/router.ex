defmodule ExMonApiWeb.Router do
  use ExMonApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"] # Accepts only plugged codes
  end

  # All authorization related issues now must be allowed thru the pipeline plugs
  pipeline :auth do
    plug ExMonApiWeb.Auth.Pipeline
  end

  # Public Routes
  # All routes here are piped thru /api/...
  scope "/api", ExMonApiWeb do
    pipe_through :api
    # By default the router will create ALL route types, but you can limit the routes you want
    post "/trainers", TrainersController, :create
    post "/trainers/signin", TrainersController, :sign_in
    get "/pokemon/:name", PokemonController, :show # We're not building the resources here, just the single GET route
  end

  # Private Routes (piped thru :auth plugs)
  scope "/api", ExMonApiWeb do
    pipe_through [:api, :auth]
    # By default the router will create ALL route types, but you can limit the routes you want
    resources "/trainers", TrainersController, only: [:show, :delete, :update]
    resources "/trainer_pokemon", TrainerPokemonController, only: [:create, :show, :delete, :update]
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Application.compile_env(:ex_mon_api, :env) in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]
      live_dashboard "/dashboard", metrics: ExMonApiWeb.Telemetry
    end
  end

  # Creating a scope outside the dashboard
  scope "/", ExMonApiWeb do
    pipe_through :api

    get "/", WelcomeController, :index

  end
end
