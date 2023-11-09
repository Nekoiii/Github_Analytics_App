FactoryBot.define do
  factory :repository do
    owner factory: %i[user]

    name { 'Test Repo' }
  end
end
