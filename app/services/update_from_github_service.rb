# The ways to update attributes for ActiveRecord: https://morizyun.github.io/ruby/active-record-attributes-save-update.html
# save v.s update: https://www.audia.jp/blog/rubyonrails-activerecord-update-method-comparison/

class UpdateFromGithubService
  class << self
    def update_data_from_github
      github_repositories = GithubAppService.fetch_data_from_github
      return if github_repositories.blank?

      update_repositories(github_repositories)
    end

    private

    def update_repositories(github_repositories)
      github_repositories.each do |github_repo|
        repo = Repository.update_from_fetched_github_data(github_repo[:info])

        github_repo[:collaborators].each do |user_info|
          User.update_from_fetched_github_data(user_info)
        end

        all_prs = update_prs(github_repo[:pullRequests], repo)
        Statistic.update_from_fetched_github_data(repo, all_prs)
      end
    end

    def update_prs(prs, repo)
      all_prs = []
      prs.each do |pr|
        pr = PullRequest.update_from_fetched_github_data(pr, repo)
        all_prs.push(pr)
      end

      all_prs
    end
  end
end
