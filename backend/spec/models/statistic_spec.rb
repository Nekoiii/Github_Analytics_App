require 'rails_helper'

RSpec.describe Statistic do
  let!(:repo1) { create(:repository) }
  let!(:pr1) { create(:pull_request) }
  let!(:user1) { create(:user, github_login: 'user1') }
  let!(:user2) { create(:user, github_login: 'user2') }

  let!(:user1_sep_prs) { create_list(:pull_request, 2, author: user1, merged_at: '2023-9-15T01:52:29Z') }
  let!(:user1_oct_prs) { create_list(:pull_request, 3, author: user1, merged_at: '2023-10-15T01:52:29Z') }
  let!(:user1_prs) { user1_sep_prs + user1_oct_prs }
  let!(:user2_sep_prs) { create_list(:pull_request, 4, author: user2, merged_at: '2023-9-10T01:52:29Z') }
  let!(:user2_oct_prs) { create_list(:pull_request, 5, author: user2, merged_at: '2023-10-10T01:52:29Z') }
  let!(:user2_prs) { user2_sep_prs + user2_oct_prs }
  let!(:all_prs) { user1_prs + user2_prs }

  let(:approved_reviews) { create_list(:review, 10, pull_request: pr1, state: 'approved') }
  let(:pending_reviews) { create_list(:review, 20, pull_request: pr1, state: 'pending') }

  describe '#update_from_fetched_github_data' do
    it 'update from fetched github data' do
      expect {
        described_class.update_from_fetched_github_data(repo1, all_prs)
      }.to change(described_class, :count).by(6)
    end
  end
end
