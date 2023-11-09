require 'rails_helper'

RSpec.describe 'query_statistics', type: :request do
  let!(:repo1) { create(:repository) }
  let!(:user1) { create(:user, github_login: 'user1') }
  let!(:statistics1) {
    create_list(:statistic, 1,
                repository: repo1,
                is_overall: true,
                year: 2023,
                month: 9)
  }
  let!(:statistics2) {
    create_list(:statistic, 2,
                repository: repo1,
                is_overall: false,
                user: user1,
                year: 2023,
                month: 9)
  }

  let(:query) {
    <<-GRAPHQL
      query ($repositoryId: ID!, $fromDate: ISO8601Date, $toDate: ISO8601Date) {
        statistic(
          repositoryId: $repositoryId
          fromDate: $fromDate
          toDate: $toDate
        ) {
          year
          month
          user {
            id
            githubLogin
            avatarUrl
          }
          isOverall
          totalMergeTime
          averageMergeTime
          mergedPrCount
          approvalCount
        }
      }
    GRAPHQL
  }
  let(:variables) {
    {
      repositoryId: repo1[:id],
      fromDate: '2023-08-01',
      toDate: '2023-12-30'
    }
  }
  let(:request_body) {
    { query:, variables: }
  }

  describe 'query for data' do
    it 'returns successful response' do
      post '/graphql', params: request_body
      expect(response).to have_http_status(:ok)

      JSON.parse(response.body)
    end
  end

  it 'has statistics' do
    expect(statistics1.size).to eq(1)
    expect(statistics2.size).to eq(2)

    expect(repo1.statistics.where(is_overall: true).count).to eq(1)
    expect(repo1.statistics.where(is_overall: false).count).to eq(2)
  end
end
