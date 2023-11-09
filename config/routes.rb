Rails.application.routes.draw do
  # root "application#hello"
  # root 'static_pages#home'

  mount GraphiQL::Rails::Engine, at: '/graphiql', graphql_path: '/graphql' if Rails.env.development?
  post '/graphql', to: 'graphql#execute'

  post '/webhooks/github', to: 'webhooks#github'
  post '/', to: 'webhooks#github'
end
