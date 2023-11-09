# Rake + whenever :https://zenn.dev/yusuke_docha/articles/2d2cfd1030f6ac

require_relative '../../app/services/update_from_github_service'

namespace :github do
  desc 'Fetch data from github api'
  task fetch_data: :environment do
    p Time.current
    p 'rake-----github_fetch--rake----'
    UpdateFromGithubService.update_data_from_github
  end
end
