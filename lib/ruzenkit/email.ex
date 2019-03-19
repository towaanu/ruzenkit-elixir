defmodule Ruzenkit.Email do
  import Bamboo.Email
  alias Ruzenkit.Mailer

  def welcome_email do
    new_email(
      to: "john@gmail.com",
      from: "support@myapp.com",
      subject: "Welcome to the app.",
      html_body: "<strong>Thanks for joining!</strong>",
      text_body: "Thanks for joining!"
    )
  end

  defp base_email do
    new_email()
    |> from("store@ruzenkit.com")
  end

  def order_email(params \\ []) do
    base_email()
    |> to(params[:email])
    |> subject("Your order !!!")
    |> html_body("<strong>Hey it's your order</strong>")

    # |> text_body("welcome")
  end

  def forgot_password_email(email: email, token: token) do
    base_email()
    |> to(email)
    |> subject("[Ruzenkit] Forgotten password")
    |> html_body("
    <strong>You forgot your passsword :(</strong>
    Here is your <a href=\"http://localhost:3000/resetpassword/#{token}\">reset link</a>
    ")
  end

  def send_mail(mail), do: mail |> Mailer.deliver_now()
end
