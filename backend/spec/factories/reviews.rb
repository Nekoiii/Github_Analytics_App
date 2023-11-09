FactoryBot.define do
  factory :review do
    pull_request
    author factory: %i[user]

    state { 'approved' }
  end
end
