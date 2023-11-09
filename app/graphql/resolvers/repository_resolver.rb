module Resolvers
  class RepositoryResolver < GraphQL::Schema::Resolver
    type Types::RepositoryType, null: true

    argument :id, ID, required: false
    argument :name, String, required: false
    argument :owner_github_login, String, required: false

    def resolve(id: nil, name: nil, owner_github_login: nil)
      if id
        repo = Repository.repo_by_id(id)
        return repo
      end

      if name && owner_github_login
        repo = Repository.repo_by_name_and_owner(name, owner_github_login)
        return repo
      end

      raise GraphQL::ExecutionError, 'Must provide id or name && owner_github_login !!!!'
    end
  end
end
