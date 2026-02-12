defmodule SampleAppWeb.SessionController do
  use SampleAppWeb, :controller
  alias SampleApp.Accounts
  alias SampleAppWeb.AuthPlug

  def new(conn, _params) do
    conn
    |> assign(:page_title, "Login")
    |> render(:login, changeset: Accounts.change_user(%Accounts.User{}))
  end

  def create(conn, %{
        "user" => %{
          "email" => email,
          "password" => password,
          "remember" => remember
        }
      }) do
    case Accounts.authenticate_by_email_and_pass(email, password) do
      {:ok, user} ->
        conn = AuthPlug.login(conn, user)
        conn = if remember do
          AuthPlug.remember(conn, user)
        else
          delete_resp_cookie(conn, "remember_token")
        end
        conn
        |> put_flash(:info, "Welcome to the Sample App!")
        |> AuthPlug.redirect_back_or(~p"/users/#{user.id}")

      _ ->
        conn
        |> put_flash(:error, "Invalid credentials")
        |> render(:login, changeset: Accounts.change_user(%Accounts.User{}))
    end
  end

  def delete(conn, _params) do
    conn
    |> AuthPlug.logout()
    |> redirect(to: ~p"/")
  end
end
