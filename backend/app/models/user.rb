class User < ApplicationRecord
  has_many :authored_pull_requests, class_name: 'PullRequest', foreign_key: 'author_id', dependent: :nullify, inverse_of: :author
  has_many :merged_pull_requests, class_name: 'PullRequest', foreign_key: 'merger_id', dependent: :nullify, inverse_of: :merger
  has_many :authored_reviews, class_name: 'Review', foreign_key: 'author_id', dependent: :nullify, inverse_of: :author
  has_many :statistics, dependent: :nullify
  has_many :owned_repositories, class_name: 'Repository', foreign_key: 'owner_id', dependent: :nullify, inverse_of: :owner

  validates :github_login, presence: true

  class << self
    def update_from_fetched_github_data(data)
      user = User.find_or_initialize_by(github_login: data['login'])
      user.avatar_url = data['avatarUrl']
      user.save!
      user
    end
  end
end
