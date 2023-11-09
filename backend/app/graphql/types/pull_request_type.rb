module Types
  class PullRequestType < Types::BaseObject
    field :title, String, null: false, description: 'The title of the pull request'
    field :number, Integer, null: false, description: 'The number of the pull request'
    field :author, String, null: false, description: 'The author of the pull request'
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false, description: 'The creation date of the pull request'
  end
end
