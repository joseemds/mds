defmodule MdsWeb.SchemaTest do
  use MdsWeb.ConnCase

  @list_users_query """

  query {
    users {
      id
      username
    }
  }

  """

  test "query: list users", %{conn: conn} do
    conn =
      conn
      |> post("/api", %{
        "query" => @list_users_query
      })

    assert json_response(conn, 200) == %{
             "data" => %{"users" => []}
           }
  end
end
