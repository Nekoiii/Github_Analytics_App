module Types
  class RepositoryType < Types::BaseObject
    field :name, String, null: false, description: 'The name of the repository'
    field :description, String, null: true, description: 'The description of the repository'
    field :url, String, null: true
    field :github_created_at, GraphQL::Types::ISO8601DateTime, null: true
  end
end
