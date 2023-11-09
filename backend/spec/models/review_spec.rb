require 'rails_helper'

RSpec.describe Review do
  let!(:pr1) { create(:pull_request) }
  let!(:user1) { create(:user, github_login: 'user1') }

  let(:review_hash) {
    { 'author' => { 'login' => user1[:github_login] },
      'state' => 'APPROVED' }
  }

  describe '#update_or_create' do
    it 'create a new review' do
      expect {
        described_class.update_or_create([review_hash], pr1[:id])
      }.to change(described_class, :count).by(1)
    end
  end
end
