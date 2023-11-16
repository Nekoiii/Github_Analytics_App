class Repository < ApplicationRecord
  belongs_to :owner, polymorphic: true, inverse_of: :owned_repositories
  
  has_many :pull_requests, dependent: :destroy, inverse_of: :repository
  has_many :statistics, dependent: :destroy

  class << self
    def update_from_fetched_github_data(data)
      Rails.logger.debug { "Repository--update_from_fetched_github_data---: #{data}" }
      owner = User.find_or_create_by(github_login: data.dig('owner', 'login'))

      repo = owner.owned_repositories.find_or_initialize_by(github_id: data['id'])
      repo.name = data['name']
      repo.description = data['description']
      repo.github_created_at = data['createdAt']
      repo.save!
      repo
    end

    def repo_by_id(id)
      repo = Repository.find_by(id:)

      Rails.logger.debug { "repositoryResolver--find_by_id---: #{repo.inspect}" }
      repo
    end

    def repo_by_name_and_owner(name, owner_github_login)
      owner = User.find_by(github_login: owner_github_login)
      return if owner.blank?

      repo = owner.owned_repositories.find_by(name:)

      Rails.logger.debug { "repositoryResolver--repo: #{repo.inspect}" }
      repo
    end
  end
end
