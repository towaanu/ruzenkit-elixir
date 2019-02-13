defmodule Ruzenkit.Repo do
  use Ecto.Repo,
    otp_app: :ruzenkit,
    adapter: Ecto.Adapters.Postgres
end
