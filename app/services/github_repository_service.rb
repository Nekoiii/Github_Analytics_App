require 'faraday'
require 'json'

class GithubRepositoryService
  class << self
    # if want to test, use (tokens[1],'Nekoiii','Rails_Tutorial')
    def fetch_repositories(tokens)
      all_repositories = []
      tokens.each do |token|
        repositories = fetch_repositories_with_one_token(token)
        all_repositories.concat(repositories) if repositories.present?
      end

      Rails.logger.debug { "fetch_repositories--all_repositories---:#{all_repositories.size}- #{all_repositories}" }
      all_repositories
    end

    private

    def fetch_repositories_with_one_token(token)
      headers = {
        'Authorization' => "Bearer #{token}",
        'Accept' => 'application/vnd.github.v3+json'
      }

      response = Faraday.get 'https://api.github.com/installation/repositories', {}, headers
      body = JSON.parse(response.body)

      fetch_repositories_handle_repos(token, body['repositories'])
    end

    def fetch_repositories_handle_repos(token, github_repos)
      repositories = []
      github_repos.each do |repo|
        repo_obj = make_repo_obj(token, repo)
        repositories.push(repo_obj)
      end
      repositories
    end

    # rubocop:disable Metrics/MethodLength
    def fetch_repo_info(token, owner, repo_name)
      query = <<-GRAPHQL
      query {
        repository(owner: "#{owner}", name: "#{repo_name}") {
          id
          name
          description
          createdAt
          owner{
            login
          }
        }
      }
      GRAPHQL
      res = GithubAppService.execute_query(token, query)

      res.dig('data', 'repository')
    end

    # rubocop:enable Metrics/MethodLength
    def make_repo_obj(token, repo)
      repo_obj = {}
      owner = repo['owner']['login']
      repo_name = repo['name']

      repo_obj[:info] = fetch_repo_info(token, owner, repo_name)
      repo_obj[:collaborators] = GithubCollaboratorService.fetch_collaborators(token, owner, repo_name)
      repo_obj[:pullRequests] = GithubPrService.fetch_pull_requests(token, owner, repo_name)
      repo_obj
    end
  end
end
