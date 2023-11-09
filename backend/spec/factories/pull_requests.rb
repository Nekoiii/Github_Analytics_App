FactoryBot.define do
  factory :pull_request do
    repository
    author factory: %i[user]

    title { 'test-pr' }
    github_created_at { '2023-10-12T01:52:29Z' }
    merged_at { '2023-10-15T01:52:29Z' }
  end
end
