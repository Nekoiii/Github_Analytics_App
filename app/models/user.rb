class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::Denylist

  has_many :authored_pull_requests, class_name: 'PullRequest', foreign_key: 'author_id', dependent: :nullify, inverse_of: :author
  has_many :merged_pull_requests, class_name: 'PullRequest', foreign_key: 'merger_id', dependent: :nullify, inverse_of: :merger
  has_many :authored_reviews, class_name: 'Review', foreign_key: 'author_id', dependent: :nullify, inverse_of: :author
  has_many :statistics, dependent: :nullify
  has_many :owned_repositories, as: :owner, class_name: 'Repository', dependent: :nullify, inverse_of: :owner
  has_many :organization_users
  has_many :organizations, through: :organization_users
  
  validates :github_login, presence: true
  validates :email, uniqueness: false
  # validates :uid, presence: false, uniqueness: { scope: :provider }
  validates :uid, presence: false

  devise :omniauthable, :jwt_authenticatable,
         omniauth_providers: %i[github],
         jwt_revocation_strategy: self

  class << self
    def update_from_fetched_github_data(data)
      user = User.find_or_initialize_by(github_login: data['login'])
      user.avatar_url = data['avatarUrl']
      user.save!
      user
    end

    def from_omniauth(auth)
      user = User.find_or_create_by(github_login: auth.extra.raw_info.login)
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]

      user.save!
      user
    end
  end
end
