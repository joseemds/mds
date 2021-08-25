defmodule Mds.Factory do
  @moduledoc false
  def user_factory do
    %{
      username: Faker.Internet.user_name(),
      email: Faker.Internet.email(),
      password: "Secretpassword$123"
    }
  end
end
