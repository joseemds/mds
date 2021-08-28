defmodule Mds.Fixtures do
  @moduledoc false
  use ExMachina.Ecto, repo: Mds.Repo

  def fixture(:user) do
    insert(:user)
  end

  def fixture(:register_user) do
    {:ok, user} =
      user_factory2()
      |> Mds.Accounts.register_user()

    user |> Map.put(:password, "Secretpassword$123")
  end

  def user_factory do
    %Mds.Accounts.User{
      username: Faker.Internet.user_name(),
      email: Faker.Internet.email(),
      password: "Secretpassword$123"
    }
  end

  def user_factory2 do
    %{
      username: Faker.Internet.user_name(),
      email: Faker.Internet.email(),
      password: "Secretpassword$123"
    }
  end
end
