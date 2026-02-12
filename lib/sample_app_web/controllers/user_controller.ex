defmodule SampleAppWeb.UserController do
  use SampleAppWeb, :controller
  alias SampleApp.Accounts

  plug :logged_in_user when action in [:edit, :update]
  plug :correct_user when action in [:edit, :update]

  def sign_up(conn, _params) do
    conn
    |> assign(:page_title, "Sign up")
    |> render(:sign_up, changeset: Accounts.change_user(%Accounts.User{}))
  end

  # lib/sample_app_web/controllers/user_controller.ex

  def create(conn, %{"user" => user_params}) do
    case Accounts.create_user(user_params) do
      {:ok, user} ->
        conn
        |> SampleAppWeb.AuthPlug.login(user)
        |> put_flash(:info, "Welcome to the Sample App!")
        |> redirect(to: ~p"/users/#{user.id}")

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> render(:sign_up, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    conn
    |> assign(:page_title, user.name)
    |> render(:show, user: user)
  end

  def edit(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    changeset = Accounts.change_user(user)
    render(conn, :edit, user: user, changeset: changeset);
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)
    case Accounts.update_user(user, user_params) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "Profile updated")
        |> redirect(to: ~p"/users/#{id}")
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, user: user, changeset: changeset);
    end
  end
end
