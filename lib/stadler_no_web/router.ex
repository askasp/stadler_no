defmodule StadlerNoWeb.Router do
  use StadlerNoWeb, :router
  import Plug.BasicAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {StadlerNoWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

    # plug :put_root_layout, {StadlerNoWeb.LayoutView, :root}
  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :admins_only do
    plug :basic_auth, username: "admin", password: Application.get_env(:stadler_no, :dashboard_pwd)
  end

  import Phoenix.LiveDashboard.Router

  scope "/" do
    pipe_through [:browser, :admins_only]
    live_dashboard "/dashboard", metrics: StadlerNoWeb.Telemetry
  end

    
  scope "/", StadlerNoWeb do
    pipe_through :browser

    # Pokemon route


    live "/*page", PageLive, :index
  end



  # Other scopes may use custom stacks.
  # scope "/api", StadlerNoWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
end
