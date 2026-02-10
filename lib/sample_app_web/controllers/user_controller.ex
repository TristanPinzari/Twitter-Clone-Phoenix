defmodule SampleAppWeb.UserController do
  use SampleAppWeb, :controller

  def sign_up(conn, _params) do
    conn
    |> assign(:page_title, "Sign up")
    |> render(:sign_up)
  end

  def create(_conn, %{user: user_params}) do
    user_params |> IO.inspect(label: "FORM DATA RECEIVED")
  end
end
