defmodule Mds.Guardian do
  @moduledoc false
  use Guardian, otp_app: :mds

  def subject_for_token(%{id: id}, _claims) do
    sub = to_string(id)
    {:ok, sub}
  end

  def resource_from_claims(%{"sub" => id}) do
    resource = Mds.Accounts.get_user!(id)
    {:ok, resource}
  end
end
