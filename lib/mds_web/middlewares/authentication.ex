defmodule MdsWeb.Middlewares.Authentication do
  @behaviour Absinthe.Middleware

  def call(resolution, _config) do
    case resolution.context do
      %{current_user: _} ->
        resolution

      _ ->
        resolution
        |> Absinthe.Resolution.put_result(
          {:error, "Unauthenticated, please provide an Authentication Token"}
        )
    end
  end
end
