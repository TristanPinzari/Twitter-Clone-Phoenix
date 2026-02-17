defmodule SampleAppWeb.MicropostController do
  use SampleAppWeb, :controller
  alias SampleApp.Posts
  alias SampleApp.Posts.Micropost

  plug :logged_in_user when action in [:index, :create, :delete]
  plug :correct_post_owner when action in [:delete]
  plug SampleAppWeb.MicropostPlug when action in [:create, :index]

  def index(conn, _params) do
  end

  def create(conn, %{"micropost" => micropost_params}) do
    case Posts.create_micropost(
           Map.take(micropost_params, ["content", "image"]),
           conn.assigns.current_user
         ) do
      {:ok, %Micropost{}} ->
        conn
        |> put_flash(:info, "Micropost created!")
        |> redirect(to: ~p"/")

      {:error, %Ecto.Changeset{} = changeset} ->
        page_data = SampleAppWeb.HelperFunctions.params_to_page_data()

        conn
        |> assign(:page_title, "Home")
        |> render(:home,
          changeset: changeset,
          posts: page_data.posts,
          page: page_data.current_page,
          total_pages: page_data.total_pages
        )
    end
  end

  def delete(conn, %{"id" => post_id}) do
    post = Posts.get_micropost!(post_id)

    conn =
      case Posts.delete_micropost(post) do
        {:ok, _} ->
          put_flash(conn, :info, "Post deleted")

        _ ->
          put_flash(conn, :error, "Post not deleted. Something went wrong")
      end

    redirect(conn, to: ~p"/")
  end

  def correct_post_owner(conn, _opts) do
    post = Posts.get_micropost!(conn.params["id"])

    if post.user_id == conn.assigns.current_user.id do
      assign(conn, :micropost, post)
    else
      conn
      |> put_flash(:error, "You are not authorized to do this.")
      |> redirect(to: ~p"/")
      |> halt()
    end
  end
end
