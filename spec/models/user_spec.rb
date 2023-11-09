require 'rails_helper'
require 'spec_helper'

# Some articles about rspec test:
# https://qiita.com/tatsurou313/items/c923338d2e3c07dfd9ee
# https://semaphoreci.com/community/tutorials/getting-started-with-rspec
RSpec.describe User do
  let!(:user1) { create(:user, github_login: 'user1', avatar_url: 'www.user1_avatar.com') }

  describe 'validations' do
    it 'is valid' do
      expect(user1).to be_valid
    end

    it 'gets user name' do
      expect(user1.github_login).to eq 'user1'
    end
  end

  describe '.update_from_fetched_github_data' do
    let(:github_data) do
      {
        'login' => 'github_user1',
        'avatarUrl' => 'www.xxx.com'
      }
    end

    context 'when user does not exist' do
      it 'creates a new user' do
        expect { described_class.update_from_fetched_github_data(github_data) }.to change(described_class, :count).by(1)
        user = described_class.find_by(github_login: 'github_user1')
        expect(user.avatar_url).to eq('www.xxx.com')
      end
    end

    context 'when user already exists' do
      # let() v.s let!(): https://qiita.com/clbcl226/items/3db2189f75747b4af2d3
      let!(:old_user) { described_class.create(github_login: 'github_user1', avatar_url: 'www.yyyyy.com') }

      it 'updates the existing user with the new data' do
        expect { described_class.update_from_fetched_github_data(github_data) }.not_to change(described_class, :count)
        old_user.reload
        expect(old_user.avatar_url).to eq('www.xxx.com')
      end
    end
  end
end
