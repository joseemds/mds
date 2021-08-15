defmodule MdsWeb.Schema.AccountTypes do
  use Absinthe.Schema.Notation

  object :user do
    field :id, :id
    field :username, :string
    field :email, :string
  end

  input_object :user_register do
    field :username, :string
    field :email, :string
    field :password, :string
  end

  enum :login_type do
    value(:email, as: :email)
    value(:username, as: :username)
  end

  input_object :user_login do
    field :type, :login_type
    field :login, :string
    field :password, :string
  end
end
