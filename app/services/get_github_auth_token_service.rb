require "openssl"
require "jwt"

class GetGithubAuthTokenService < BaseService
  class FetchError < StandardError; end
  class FileNotFound < StandardError; end

  def run
    jwt = generate_jwt
    installation_id = get_installation_id(jwt)
    url = "https://api.github.com/app/installations/#{installation_id}/access_tokens"
    response = HTTParty.post(url, headers: headers(jwt), body: {})

    raise FetchError unless response["token"].present?

    GithubAuthToken.create!(token: response["token"], expire_date: response["expires_at"])

    response["token"]
  end

  private

  def generate_jwt
    key_file_path = Rails.root.join('github_key.pem')

    raise FileNotFound unless File.exist?(key_file_path)

    private_pem = File.read(key_file_path)
    private_key = OpenSSL::PKey::RSA.new(private_pem)

    payload = {
      iat: Time.now.to_i - 60,
      exp: Time.now.to_i + (10 * 60),
      iss: ENV["APP_CLIENT_ID"]
    }

    JWT.encode(payload, private_key, "RS256")
  end

  def get_installation_id(jwt)
    # TODO: Fixed value, fix later
    owner = "LuuDai-bit"
    repo = "blog"
    url = "https://api.github.com/repos/#{owner}/#{repo}/installation"

    response = HTTParty.get(url, headers: headers(jwt))

    response["id"]
  end

  def headers(jwt)
    {
      "Authorization": "Bearer #{jwt}",
      "Accept": "application/vnd.github+json"
    }
  end
end
