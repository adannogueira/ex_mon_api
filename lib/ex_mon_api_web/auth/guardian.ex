defmodule ExMonApiWeb.Auth.Guardian do
  use Guardian, otp_app: :ex_mon_api

  def subject_for_token(%{id: id}, _claims) do
    sub = to_string(id)
    {:ok, sub}
  end

  def resource_from_claims(%{"sub" => id}) do
    resource = ExMonApi.fetch_trainer(id)
    {:ok,  resource}
  end
end
