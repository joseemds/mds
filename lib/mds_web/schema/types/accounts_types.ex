defmodule MdsWeb.Schema.Types.AccountsTypes do
  @moduledoc """
  GraphQL notations of things related to user operation
  """
  use Absinthe.Schema.Notation

  object :user do
    field :id, non_null(:id)
    field :username, non_null(:string)
    field :email, non_null(:string)
  end

  object :auth_token do
    field :token, non_null(:string)
  end

  input_object :user_register do
    field :username, non_null(:string)
    field :email, non_null(:string)
    field :password, non_null(:string)
  end

  enum :login_type do
    value(:email, as: :email)
    value(:username, as: :username)
  end

  input_object :user_login do
    field :type, non_null(:login_type)
    field :login, non_null(:string)
    field :password, non_null(:string)
  end
end
