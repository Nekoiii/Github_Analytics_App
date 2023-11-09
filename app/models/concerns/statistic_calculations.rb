module StatisticCalculations
  extend ActiveSupport::Concern

  class_methods do
    private

    def total_merge_time(prs)
      total_merge_time = 0

      prs.each do |pr|
        merge_time = pr['merged_at'] - pr['github_created_at']

        total_merge_time += merge_time
      end

      total_merge_time
    end

    def approval_count(prs)
      count = 0
      prs.each do |pr|
        reviews = Review.where(
          pull_request_id: pr.id,
          state: 'approved'
        )
        count += reviews.length unless reviews.empty?
      end
      count
    end
  end
end
