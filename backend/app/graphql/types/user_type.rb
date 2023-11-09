module Types
  class UserType < Types::BaseObject
    field :id, ID, null: false
    field :github_login, String, description: 'The login name of the collaborator'
    field :avatar_url, String, description: 'The avatar URL of the collaborator'
  end
end
