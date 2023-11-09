class GithubCollaboratorService
  class << self
    # rubocop:disable Metrics/MethodLength
    def fetch_collaborators(token, owner, repo_name)
      query = <<-GRAPHQL
        query {
          repository(owner: "#{owner}", name: "#{repo_name}") {
            collaborators(first: 100 %<after_part>s) {
              pageInfo {
                endCursor
                hasNextPage
              }
              edges{
                node {
                  login
                  avatarUrl
                }
              }
            }
          }
        }
      GRAPHQL

      PaginationService.do_pagination(token, query, %w[repository collaborators])
    end
    # rubocop:enable Metrics/MethodLength
  end
end
