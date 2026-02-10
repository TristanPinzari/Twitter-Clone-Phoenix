defmodule SampleAppWeb.PageController do
  use SampleAppWeb, :controller

  def home(conn, _params) do
    conn
    |> assign(:page_title, "Home")
    |> render(:home)
  end

  def help(conn, _params) do
    conn
    |> assign(:page_title, "Help")
    |> render(:help)
  end

  def about(conn, _params) do
    conn
    |> assign(:page_title, "About")
    |> render(:about)
  end

  def contact(conn, _params) do
    conn
    |> assign(:page_title, "Contact")
    |> render(:contact)
  end
end
