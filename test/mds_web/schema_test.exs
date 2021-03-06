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

      users = Mds.Accounts.list_users()

      assert length(users) > 0
    end
  end

  describe "loginUser mutation:" do
    setup do
      user = Fixtures.fixture(:register_user)

      %{user: Map.take(user, ~w(username email password)a)}
    end

    test "loginUser should return a token that retrieves the user", %{
      conn: conn,
      user: user
    } do
      conn =
        conn
        |> post("/api", %{
          "query" => @login_user_mutation,
          "variables" => %{
            user: %{type: "EMAIL", login: user.email, password: user.password}
          }
        })

      user = Map.delete(user, :password)

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
      user = Fixtures.insert(:user)

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

    test "CurrentUser without Authorization header should return error and reason", %{conn: conn} do
      conn =
        conn
        |> post("/api", %{"query" => @current_user_query})

      response = json_response(conn, 200)

      assert response["data"]["currentUser"] == nil

      [error | []] = response["errors"]

      error_message = error["message"]

      assert error_message == "Unauthenticated, please provide an Authentication Token"
    end
  end
end
