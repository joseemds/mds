defmodule Mds.Guardian do
  @moduledoc false
  use Guardian, otp_app: :mds

  def subject_for_token(resource, _claims) do
    sub = to_string(resource.id)
    {:ok, sub}
  end

  def resource_from_claims(claims) do
    id = claims["sub"]
    resource = Mds.Accounts.get_user!(id)
    {:ok, resource}
  end
end
