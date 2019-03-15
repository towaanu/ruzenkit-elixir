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

  def send_mail, do: order_email() |> Mailer.deliver_now()


end
