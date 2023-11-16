class Organization < ApplicationRecord
  has_many :owned_repositories, as: :owner, class_name: 'Repository', inverse_of: :owner
  has_many :organization_users
  has_many :users, through: :organization_users

end
