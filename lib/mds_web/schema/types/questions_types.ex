defmodule MdsWeb.Schema.Types.QuestionsTypes do
  use Absinthe.Schema.Notation

  object :question do
    field :id, non_null(:id)
    field :title, non_null(:string)
    field :body, non_null(:string)
  end
end
