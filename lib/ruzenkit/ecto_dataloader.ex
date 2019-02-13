defmodule Ruzenkit.EctoDataloader do
  def data() do
    Dataloader.Ecto.new(Ruzenkit.Repo, query: &query/2)
  end

  def query(queryable, _params) do
    queryable
  end
end
