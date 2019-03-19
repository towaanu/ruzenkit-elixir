defmodule RuzenkitWeb.EmailView do
  use RuzenkitWeb, :view

  @base_url "http://localhost:3000/resetpassword/"
  def forgot_password_url(token), do: "#{@base_url}#{token}"

end
