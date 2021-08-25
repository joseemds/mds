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

  @current_user_query """
  query {
    currentUser {
      username
    }
  }
  """

  describe "Users query" do
    test "should return an empty list when no user is provided", %{conn: conn} do
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

  describe "createUser mutation" do
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

      assert length(users) > 0
    end
  end

  describe "registerUser mutation" do
    setup do
      {:ok, user} =
        Mds.Accounts.register_user(%{
          username: "test1",
          email: "test1@email.com",
          password: "Testpassword1234"
        })

      %{user: Map.take(user, ~w(username email)a)}
    end

    test "registerUser should return a token that retrieves the user", %{conn: conn, user: user} do
      conn =
        conn
        |> post("/api", %{
          "query" => @login_user_mutation,
          "variables" => %{
            user: %{type: "EMAIL", login: "test1@email.com", password: "Testpassword1234"}
          }
        })

      token = json_response(conn, 200)["data"]["loginUser"]["token"]

      db_user =
        with {:ok, claims} <- Mds.Guardian.decode_and_verify(token) do
          {:ok, db_user} = Mds.Guardian.resource_from_claims(claims)

          db_user |> Map.take(~w(username email)a)
        end

      assert Map.values(user) == Map.values(db_user)
    end
  end

  describe "CurrentUser queries" do
    setup do
      {:ok, user} =
        Mds.Accounts.register_user(%{
          username: "Test1",
          email: "email@email.com",
          password: "Passwordtest123"
        })

      {:ok, token, _claims} = Mds.Guardian.encode_and_sign(user)

      %{user: user, token: token}
    end

    test "CurrentUser should return the user equivalent to the JWT token", %{
      conn: conn,
      user: user,
      token: token
    } do
      conn =
        conn
        |> put_req_header("authorization", "Bearer #{token}")
        |> post("/api", %{"query" => @current_user_query})

      result = conn |> json_response(200)

      %{username: username} = user

      assert result["data"]["currentUser"]["username"] == username
    end

    @tag :skip
    test "CurrentUser without Authorization header should return error and reason", %{conn: conn} do
      conn =
        conn
        |> post("/api", %{"query" => @current_user_query})
    end
  end
end
