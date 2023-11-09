module Types
  class StatisticType < Types::BaseObject
    field :id, ID, null: false, description: 'The id of the statistic'
    field :repository_id, ID, null: false
    field :user_id, ID
    field :user, UserType, null: true
    field :is_overall, Boolean, null: false
    field :year, Integer, null: true
    field :month, Integer, null: true
    field :total_merge_time, Float
    field :average_merge_time, Float
    field :merged_pr_count, Integer
    field :approval_count, Integer
  end
end
