defmodule ErsWeb.Router do
  use ErsWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug Ers.Plugs.AuthPipeline
  end

  scope "/api/auth", ErsWeb do
    pipe_through :api

    post "/login", AuthController, :login
    post "/register", AuthController, :register
  end

  scope "/api", ErsWeb do
    pipe_through :api

    get "/facilities", FacilityController, :get_facilities
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:ers, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: ErsWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
