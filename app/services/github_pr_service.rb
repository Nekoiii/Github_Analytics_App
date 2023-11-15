class GithubPrService
  class << self
    # rubocop:disable Metrics/MethodLength
    def fetch_pull_requests(token, owner, repo_name)
      Rails.logger.debug "begin to do fetch_pull_requests--"
      query = <<-GRAPHQL
        query {
          repository(owner: "#{owner}", name: "#{repo_name}") {
            pullRequests(first: 100 %<after_part>s) {
              pageInfo {
                endCursor
                hasNextPage
              }
              edges {
                node {
                  id
                  author{
                    login
                  }
                  mergedBy{
                    login
                  }
                  mergeCommit{
                    message
                  }
                  number
                  title
                  permalink
                  state
                  closed
                  merged
                  isDraft
                  createdAt
                  publishedAt
                  updatedAt
                  mergedAt
                  closedAt
                  headRefName
                  headRefOid
                  baseRefName
                  baseRefOid
                  reviewDecision
                  reviews(first:100){
                    pageInfo {
                      endCursor
                      hasNextPage
                    }
                    edges{
                      node{
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
          }
        }
      GRAPHQL

      prs = PaginationService.do_pagination(token, query, %w[repository pullRequests])

      prs.each do |pr|
        deal_with_pr(token, pr)
      end

      Rails.logger.debug { "fetch_pull_requests--prs---: #{prs}" }

      prs
    end

    private

    # rubocop:enable Metrics/MethodLength
    def deal_with_pr(token, pull_request)
      Rails.logger.debug "--deal_with_pr---: #{pull_request}"
      reviews = pull_request['reviews']
      rev_has_next = reviews.dig('pageInfo', 'hasNextPage')

      if rev_has_next
        reviews = GithubReviewService.fetch_reviews(token, pull_request['id'])
        pull_request['reviews'] = reviews
        return pull_request
      end

      pull_request['reviews'] = reviews['edges'].map { |edge| edge['node'] }
      pull_request
    end
  end
end
