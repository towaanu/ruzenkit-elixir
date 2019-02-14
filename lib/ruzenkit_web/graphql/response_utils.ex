defmodule RuzenkitWeb.Graphql.ResponseUtils do

  def unauthorized_response, do: %{message: "unauthorized", code: "UNAUTHORIZED"}

end
