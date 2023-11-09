class GithubReviewService
  class << self
    # rubocop:disable Metrics/MethodLength

    def fetch_reviews(token, pr_id)
      query_template = <<-GRAPHQL
      query {
        node(id: "#{pr_id}") {
          ... on PullRequest {
            id
            reviews(first:100 %<after_part>s) {
              pageInfo {
                endCursor
                hasNextPage
              }
              edges {
                node {
                  pullRequest{
                    id
                  }
                  author{
                    login
                  }
                  state
                }
              }
            }
          }
        }
      }
      GRAPHQL

      PaginationService.do_pagination(token, query_template, %w[node reviews])
    end

    # rubocop:enable Metrics/MethodLength
  end
end
