# Create GitHub Apps

- GitHub Apps を構築するためのクイックスタート：  
  https://docs.github.com/ja/apps/creating-github-apps/writing-code-for-a-github-app/quickstart
- Video: (create, settings, webhooks...)  
  https://www.youtube.com/watch?v=l3g41dGObJ4

# Settings for Github App

- (Github)Account Settings -> Developer Settings -> GitHub Apps -> Edit

# Set webhooks for github app

(Webhooks enable the GitHub App to receive real-time notifications when subscribed events happen on GitHub.)

(I am using smee.io for Webhook URL in this project (Webhook URL is setting in the [Developer Settings] on github app).)

https://docs.github.com/en/rest/apps/webhooks?apiVersion=2022-11-28

- [backend/.env](\* Don't forget to add it on .gitignore !!!!)  
  APP_ID="YOUR_APP_ID"
  WEBHOOK_SECRET="YOUR_WEBHOOK_SECRET"
  PRIVATE_KEY_PATH="YOUR_PRIVATE_KEY_PATH"
- [backend/config/environments/development.rb]  
  config.hosts << "smee.io"
- [backend/app/controllers/webhooks_controller.rb]  
  -> Some functions used to handle Webhooks
- [backend/config/routes.rb]  
  post "/webhooks/github", to: "webhooks#github"

- Check if it's works:
  - At the terminal:（3001 is the port i set in docker-compose.yml for api service）  
    smee -u https://smee.io/YOUR_SMEE_URL -p 3001
  - Open the link https://smee.io/YOUR_SMEE_URL,  
    and click the icon[Redeliver this payload],
    and the messages will be displayed in the terminal.

# Fetch data from Github Graphql API

Github Graphql API:  
https://docs.github.com/ja/graphql

＊＊＊Very useful tool !!!! Easy to find all the schema here:
GitHub GraphQL Explorer：  
https://docs.github.com/en/graphql/overview/explorer

- [backend/app/controllers/graphql_controller.rb]  
  -> Some functions used to handle GraphQL queries
- [backend/config/routes.rb]  
  Set:  
  post "/graphql", to: "graphql#execute"
- [backend/app/services/github_app_service.rb]  
  -> Some services for Github App, such as generating JWT, obtaining installation information, obtaining access tokens for installation, and executing GraphQL queries.
- [backend/app/services/github_user_service.rb]  
  -> Some services about Github user

# Create Rails API

- [backend/app/graphql/types/query_type.rb]  
  -> Added a GraphQL field to fetch pull requests.
- [backend/app/controllers/api_controller.rb]  
  -> Serve API endpoints.
- [backend/config/routes.rb]
  Define route for fetching pull requests data:  
  get "/pull_requests_data", to: "api#pull_requests_data"

# Show data on frontend.

- [frontend/app/src/components/GithubPullRequests.tsx]  
  -> A React component to fetch and display Github pull requests data from backend API.
