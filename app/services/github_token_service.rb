require 'jwt'
require 'faraday'
require 'json'

class GithubTokenService
  private_key_base64 = ENV['PRIVATE_KEY_BASE64']
  private_key_string = Base64.decode64(private_key_base64)
  PRIVATE_KEY = OpenSSL::PKey::RSA.new(private_key_string)

  # PRIVATE_KEY = OpenSSL::PKey::RSA.new(File.read(ENV.fetch('PRIVATE_KEY_PATH', nil)))
  MAX_EXPIRATION_TIME = 10 # minutes

  class << self
    # Fetch github app installation token
    def fetch_installation_tokens
      installations, jwt = fetch_installations
      return unless installations

      tokens = []
      installations.each do |installation|
        token = fetch_installation_token(installation, jwt)
        tokens.push(token) if token.present?
      end
      Rails.logger.debug "fetch_installation_tokens--tokens---: #{tokens}"
      tokens
    end

    private

    def generate_jwt
      payload = {
        iat: Time.now.to_i,
        exp: Time.now.to_i + (MAX_EXPIRATION_TIME * 60),
        iss: ENV.fetch('GITHUB_APP_ID', nil)
      }

      JWT.encode(payload, PRIVATE_KEY, 'RS256')
    end

    def fetch_installations
      jwt = generate_jwt

      response = Faraday.get 'https://api.github.com/app/installations', {}, {
        'Authorization' => "Bearer #{jwt}",
        'Accept' => 'application/vnd.github.v3+json'
      }

      installations = JSON.parse(response.body)
      Rails.logger.debug { "fetch_installations--installations---: #{installations}" }

      [installations, jwt]
    end

    def fetch_installation_token(installation, jwt)
      installation_id = installation['id']
      response = Faraday.post "https://api.github.com/app/installations/#{installation_id}/access_tokens", {}, {
        'Authorization' => "Bearer #{jwt}", # Use the JWT to get the installation token
        'Accept' => 'application/vnd.github.v3+json'
      }
      JSON.parse(response.body)['token']
    end
  end
end
