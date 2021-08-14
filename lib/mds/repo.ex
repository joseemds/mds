defmodule Mds.Repo do
  use Ecto.Repo,
    otp_app: :mds,
    adapter: Ecto.Adapters.Postgres
end
