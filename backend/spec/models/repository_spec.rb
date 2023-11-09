require 'rails_helper'

RSpec.describe Repository do
  let!(:github_data) {
    { 'id' => 'github_id',
      'name' => 'Github Repository',
      'description' => 'xxx',
      'createdAt' => '2023-08-25T07:05:46Z',
      'owner' => { 'login' => 'Github User' } }
  }

  describe '#update_from_fetched_github_data' do
    it 'update from fetched github data' do
      expect {
        described_class.update_from_fetched_github_data(github_data)
      }.to change(described_class, :count).by(1)
    end
  end
end
