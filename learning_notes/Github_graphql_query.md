# Github Rest API endpoints: https://docs.github.com/en/rest?apiVersion=2022-11-28

# Github GraphQL API Queries docs: https://docs.github.com/en/graphql/reference

# 2 differents ways to query for querying github graphql API

- Way.1 (Using repository field):

```ruby
    """
    Directly looks into a specific repository.
    Fetches pull requests of that repository.
    Straightforward but doesn't allow filterings (likes filtering by author).
    """
    query = <<-GRAPHQL
    query {
      repository(owner:"#{owner}", name:"#{repo_name}") {
        pullRequests(first:10, orderBy: {field: CREATED_AT, direction: DESC}) {
          nodes {
            title
            number
            author {
              login
            }
            createdAt
            }
          }
        }
      }
    GRAPHQL

    response = GithubAppService.fetch_data_from_github(query)
    # Rails.logger.debug "get_pull_requests (Way.1)--response---: #{response}"
    esponse["data"]["repository"]["pullRequests"]["nodes"]
```

- Way.2 (Using search field):

```ruby
    """
    Uses GitHub's search system.
    Can search across all of GitHub, not just one repository.
    More flexible and can filter results by author, type, etc.
    """
    query = <<-GRAPHQL
    query {
      search(query: "repo:Nekoiii/Rails_Tutorial type:pr author:Nekoiii2", type: ISSUE, first: 100) {
        edges {
          node {
            ... on PullRequest {
              title
              number
              author {
                login
              }
              createdAt
            }
          }
        }
      }
    }
    GRAPHQL

    response = GithubAppService.fetch_data_from_github(query)
    # Rails.logger.debug "get_pull_requests (Way.2)--response---: #{response}"
    response["data"]["search"]["edges"].map { |edge| edge["node"] }
```
