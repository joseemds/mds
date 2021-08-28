defmodule Mds.Fixtures do
  @moduledoc false
  use ExMachina.Ecto, repo: Mds.Repo

  def fixture(:user) do
    insert(:user)
  end

  def fixture(:question) do
    insert(:question)
  end

  def fixture(:register_user) do
    {:ok, user} =
      user_factory()
      |> Map.from_struct()
      |> Mds.Accounts.register_user()

    user |> Map.put(:password, "Secretpassword$123")
  end

  def question_factory do
    %Mds.Questions.Question{
      title: Faker.Lorem.paragraph(1),
      body: Faker.Lorem.paragraph(1..4)
    }
  end

  def user_factory do
    %Mds.Accounts.User{
      username: Faker.Internet.user_name(),
      email: Faker.Internet.email(),
      password: "Secretpassword$123"
    }
  end
end
