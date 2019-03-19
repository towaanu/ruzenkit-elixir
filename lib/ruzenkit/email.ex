defmodule Ruzenkit.Email do
  import Bamboo.Email

  use Bamboo.Phoenix, view: RuzenkitWeb.EmailView

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
    |> put_html_layout({RuzenkitWeb.LayoutView, "email.html"})
    |> put_text_layout({RuzenkitWeb.LayoutView, "email.text"})
  end

  def order_email(params \\ []) do
    base_email()
    |> to(params[:email])
    |> subject("Your order !!!")
    |> html_body("<strong>Hey it's your order</strong>")
  end

  def forgot_password_email(email: email, token: token) do
    base_email()
    |> to(email)
    |> subject("[Ruzenkit] Forgotten password")
    |> assign(:token, token)
    |> render(:forgot_password)
  end

  def send_mail(mail), do: mail |> Mailer.deliver_now()
end
