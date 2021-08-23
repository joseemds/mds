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

  @create_user_mutation """
  mutation createUser($user: UserRegister!) {
    createUser(user: $user){
      username
      email
    }
  }
  """

  @login_user_mutation """
  mutation loginUser($user: UserLogin!){
    loginUser(user: $user){
      token
    }
  }
  """

  describe "Accounts: " do
    test "Users query should return an empty list when no user is provided", %{conn: conn} do
      conn =
        conn
        |> post("/api", %{
          "query" => @list_users_query
        })

      assert json_response(conn, 200) == %{
               "data" => %{"users" => []}
             }
    end

    test "createUser mutation should insert an user into the database", %{conn: conn} do
      conn =
        conn
        |> post("/api", %{
          "query" => @create_user_mutation,
          "variables" => %{
            user: %{username: "test1", email: "test1@email.com", password: "Testpassword1234"}
          }
        })

      assert json_response(conn, 200) == %{
               "data" => %{
                 "createUser" => %{
                   "email" => "test1@email.com",
                   "username" => "test1"
                 }
               }
             }

      conn =
        conn
        |> post("/api", %{
          "query" => @list_users_query
        })

      users =
        conn
        |> json_response(200)
        |> Map.get("data")
        |> Map.get("users")

      assert users > 0
    end

    test "registerUser should return a token that retrieves the user", %{conn: conn} do
      conn =
        conn
        |> post("/api", %{
          "query" => @create_user_mutation,
          "variables" => %{
            user: %{username: "test1", email: "test1@email.com", password: "Testpassword1234"}
          }
        })

      user = conn |> json_response(200) |> Map.get("data") |> Map.get("createUser")

      conn =
        conn
        |> post("/api", %{
          "query" => @login_user_mutation,
          "variables" => %{
            user: %{type: "EMAIL", login: "test1@email.com", password: "Testpassword1234"}
          }
        })

      token =
        conn
        |> json_response(200)
        |> Map.get("data")
        |> Map.get("loginUser")
        |> Map.get("token")

      db_user =
        with {:ok, claims} <- Mds.Guardian.decode_and_verify(token) do
          {:ok, db_user} = Mds.Guardian.resource_from_claims(claims)

          Map.take(db_user, ~w(email username)a)
          |> Enum.map(fn {k, v} -> {Atom.to_string(k), v} end)
          |> Enum.into(%{})
        end

      assert user == db_user
    end
  end
end
