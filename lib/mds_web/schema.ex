defmodule MdsWeb.Schema do
  use Absinthe.Schema

  query do

    field :test, :string do
      resolve fn _,_,_ -> {:ok, "Working"} end
    end

  end
end
