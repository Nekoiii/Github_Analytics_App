FactoryBot.define do
  factory :statistic do
    repository
    user

    repository_id { 1 }
    is_overall { true }
    year { 2023 }
    month { 9 }
    merged_pr_count { 20 }
  end
end
