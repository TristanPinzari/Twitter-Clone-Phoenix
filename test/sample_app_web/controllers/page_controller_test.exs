defmodule SampleAppWeb.PageControllerTest do
  use SampleAppWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, ~p"/")
    assert html_response(conn, 200) =~ "This is the home page"
  end

  test "GET /help", %{conn: conn} do
    conn = get(conn, ~p"/help")
    assert html_response(conn, 200) =~ "Get help"
  end
end
