require 'rails_helper'

RSpec.describe PullRequest do
  let!(:repo1) { create(:repository) }
  let!(:user1) { create(:user, github_login: 'user1') }

  let!(:github_data) {
    { 'id' => 'github_id',
      'author' => { 'login' => user1[:github_login] },
      'mergedBy' => { 'login' => 'Github User' },
      'mergeCommit' => { 'message' => 'xxx' },
      'number' => 1,
      'title' => 'pr_1',
      'state' => 'MERGED',
      'closed' => true,
      'merged' => true,
      'reviews' => [
        { 'author' => { 'login' => user1[:github_login] },
          'state' => 'COMMENTED' }
      ] }
  }

  describe '#update_from_fetched_github_data' do
    it 'update from fetched github data' do
      expect {
        described_class.update_from_fetched_github_data(github_data, repo1)
      }.to change(described_class, :count).by(1)
                                          .and change(Review, :count).by(1)
    end
  end
end
