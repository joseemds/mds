defmodule Mds.Fixtures do
  @moduledoc false
  use ExMachina.Ecto, repo: Mds.Repo

  alias Mds.Factory

  def fixture(:user) do
    insert(:user, Factory.user_factory())
  end
end
