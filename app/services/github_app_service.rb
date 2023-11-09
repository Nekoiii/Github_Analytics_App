require 'jwt'
require 'faraday'
require 'json'

class GithubAppService
  class << self
    def execute_query(token, query)
      headers = {
        'Authorization' => "Bearer #{token}",
        'Accept' => 'application/vnd.github.v3+json'
      }
      body = {
        query:
      }.to_json
      response = Faraday.post 'https://api.github.com/graphql', body, headers
      JSON.parse(response.body)
    end

    def fetch_data_from_github
      tokens = GithubTokenService.fetch_installation_tokens
      return if tokens.empty?

      GithubRepositoryService.fetch_repositories(tokens)
    end
  end
end
