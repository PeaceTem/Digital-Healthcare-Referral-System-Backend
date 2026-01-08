defmodule Ers.Auth do
  use Joken.Config

  @impl true
  def token_config do
    default_claims(
      # issuer: "ers",
      skip: [:aud, :exp],
      default_exp: 60 * 60 * 3000 # 24 hours
    )
  end

  def generate_token(user) do
    claims = %{
      sub: user.id,
      email: user.email,
      role: user.role
    }

    generate_and_sign!(claims)
  end

  def verify_token(token) do
    verify_and_validate(token)
  end
end
