Rails.application.routes.draw do
  mount GraphiQL::Rails::Engine, at: '/graphiql', graphql_path: '/graphql' if Rails.env.development?
  post '/graphql', to: 'graphql#execute'

  post '/webhooks/github', to: 'webhooks#github'
  post '/', to: 'webhooks#github'

  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks',
    sessions: 'users/sessions'
  }
  post 'login', to: 'users/sessions#create'
  delete 'logout', to: 'users/sessions#destroy'
end
