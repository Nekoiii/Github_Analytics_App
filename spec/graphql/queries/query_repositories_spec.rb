require 'rails_helper'

RSpec.describe 'query_repositories', type: :request do
  let!(:user1) { create(:user, github_login: 'user1') }
  let!(:repo1) { create(:repository, owner: user1, name: 'repo1') }

  let(:query1) {
    <<-GRAPHQL
      query ($id: ID!) {
        repositoryInfo(id: $id) {
          name
          description
          url
          githubCreatedAt
        }
      }
    GRAPHQL
  }
  let(:variables1) {
    {
      id: repo1[:id]
    }
  }
  let(:request_body1) {
    { query: query1, variables: variables1 }
  }
  let(:query2) {
    <<-GRAPHQL
      query ($name: String,$ownerGithubLogin: String) {
        repositoryInfo(name: $name, ownerGithubLogin: $ownerGithubLogin) {
          name
          description
          url
          githubCreatedAt
        }
      }
    GRAPHQL
  }
  let(:variables2) {
    {
      name: repo1[:name],
      ownerGithubLogin: user1[:github_login]
    }
  }
  let(:request_body2) {
    { query: query2, variables: variables2 }
  }

  let(:variables2_invalid) {
    {
      name: repo1[:name],
      ownerGithubLogin: nil
    }
  }
  let(:request_body2_invalid) {
    { query: query2, variables: variables2_invalid }
  }

  describe 'RepositoryResolver' do
    context 'query with repository id' do
      it 'return repository info' do
        post '/graphql', params: request_body1
        expect(response).to have_http_status(:ok)

        json = JSON.parse(response.body)
        expect(json['data']['repositoryInfo']['name']).to eq('repo1')
      end
    end

    context 'query with repository name && owner' do
      it 'return repository info' do
        post '/graphql', params: request_body2
        expect(response).to have_http_status(:ok)

        json = JSON.parse(response.body)
        expect(json['data']['repositoryInfo']['name']).to eq('repo1')
      end
    end

    context 'when incorrect parameters provided' do
      it 'raises an error' do
        post '/graphql', params: request_body2_invalid
        expect(response).to have_http_status(:ok)

        json = JSON.parse(response.body)
        expect(json['errors'][0]['message']).to eql('Must provide id or name && owner_github_login !!!!')
      end
    end
  end
end
