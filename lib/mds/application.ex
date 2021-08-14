defmodule Mds.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Mds.Repo,
      # Start the Telemetry supervisor
      MdsWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Mds.PubSub},
      # Start the Endpoint (http/https)
      MdsWeb.Endpoint
      # Start a worker by calling: Mds.Worker.start_link(arg)
      # {Mds.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Mds.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    MdsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
