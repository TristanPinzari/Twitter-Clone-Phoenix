defmodule SampleAppWeb.PasswordResetController do
  use SampleAppWeb, :controller
  alias SampleApp.Accounts
  alias Accounts.User
  alias SampleAppWeb.AuthPlug

  plug :valid_user when action in [:edit, :update]

  def new(conn, _params) do
    render(conn, :new)
  end

  def create(conn, %{
        "user" => %{
          "email" => email
        }
      }) do
    with %User{} = user <- Accounts.get_user_by(email: email) do
      Accounts.send_user_password_reset_email(user)
    end

    conn
    |> put_flash(:info, "Email sent with password reset instructions")
    |> redirect(to: ~p"/")
  end

  def edit(conn, %{"id" => reset_token}) do
    user = conn.assigns.user
    changeset = Accounts.password_change_user(user)
    render(conn, :edit, changeset: changeset, reset_token: reset_token)
  end

  def update(conn, %{"id" => reset_token, "user" => user_params}) do
    user = conn.assigns.user

    case Accounts.update_user_password(user, user_params) do
      {:ok, user} ->
        conn
        |> AuthPlug.login(user)
        |> put_flash(:info, "Password has been reset.")
        |> redirect(to: ~p"/users/#{user.id}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, changeset: changeset, reset_token: reset_token)
    end
  end

  defp valid_user(conn, _opts) do
    with %{"id" => token} <- conn.params,
         {:ok, user_id} <- SampleApp.Token.verify_reset_token(token),
         %User{activated: true} = user <- Accounts.get_user(user_id) do
      conn
      |> assign(:user, user)
    else
      {:error, :expired} ->
        conn
        |> put_flash(:danger, "Password reset token expired")
        |> redirect(to: ~p"/password_resets/new")
        |> halt()

      _ ->
        conn
        |> Phoenix.Controller.put_flash(:error, "Account not activated yet")
        |> redirect(to: ~p"/")
        |> halt()
    end
  end
end
