class Statistic < ApplicationRecord
  include StatisticCalculations

  belongs_to :repository
  belongs_to :user, optional: true

  # is_overall = true: statistic for overall repository
  # is_overall = false: statistic for specific user in the repository
  attribute :is_overall, :boolean, default: true

  class << self
    def update_from_fetched_github_data(repo, all_prs)
      prs_objs = group_prs_by_merged_month_and_user(all_prs)

      prs_objs.each do |obj|
        create_or_update_statatic_with_obj(repo, obj)
      end
    end

    def statistics_during_date(repository_id, from_date, to_date)
      from_year = from_date.year
      from_month = from_date.month
      to_year = to_date.year
      to_month = to_date.month
      where(repository_id:,
            year: from_year..to_year,
            month: from_month..to_month)
        .order(:user_id)
    end

    private

    def group_prs_by_merged_month(prs)
      # *Don't forget to filter the nil values !!!!
      filtered_prs = prs.select { |pr| pr['merged_at'] }
      month_prs_groups_hash = filtered_prs.group_by do |pr|
        merged_at = pr.merged_at
        [merged_at&.year, merged_at&.month]
      end
      month_prs_groups = month_prs_groups_hash.values
      Rails.logger.debug { "month_prs_groups--: #{month_prs_groups.size}#{month_prs_groups}" }

      make_group_obj(true, month_prs_groups, is_grouped_by_month: true, is_grouped_by_user: false)
    end

    def group_prs_by_user(prs)
      user_prs_groups_hash = prs.group_by { |it| it[:author_id] }
      user_prs_groups = user_prs_groups_hash.values
      Rails.logger.debug { "group_prs_by_user--: #{user_prs_groups.size}#{user_prs_groups}" }

      make_group_obj(false, user_prs_groups, is_grouped_by_month: false, is_grouped_by_user: true)
    end

    def group_prs_by_merged_month_and_user(prs)
      month_prs_obj = group_prs_by_merged_month(prs)
      user_prs_objs = []
      month_prs_obj[:pr_groups].each do |group|
        user_prs_obj = group_prs_by_user(group)
        user_prs_objs.push(user_prs_obj)
      end

      [month_prs_obj, *user_prs_objs]
    end

    # group_obj={
    #   is_overall: true/false,
    #   pr_groups: prs_groups(list for PullRequest)
    # }
    def make_group_obj(is_overall, pr_groups, is_grouped_by_month: false, is_grouped_by_user: false)
      {
        is_overall: is_overall,
        pr_groups: pr_groups,
        is_grouped_by_month: is_grouped_by_month,
        is_grouped_by_user: is_grouped_by_user
      }
    end

    def create_or_update_statatic_with_obj(repo, obj)
      Rails.logger.debug { "create_or_update_statatic_with_obj--obj----#{obj}" }
      Rails.logger.debug 'create_or_update_statatic_with_obj--end----end'
      is_overall = obj[:is_overall]
      groups = obj[:pr_groups]

      groups.each do |group|
        handle_each_group(group, repo, is_overall)
      end
    end

    # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
    def handle_each_group(group, repo, is_overall)
      first_pr = group.first
      user_id = is_overall ? nil : first_pr.author_id
      total_merge_time = total_merge_time(group)
      approval_count = approval_count(group)
      merged_pr_count = group.length
      average_merge_time = total_merge_time / merged_pr_count

      statistic = find_or_initialize_by(
        repository_id: repo.id,
        user_id: user_id,
        is_overall: is_overall,
        year: first_pr.merged_at&.year,
        month: first_pr.merged_at&.month
      )
      statistic.update!(
        merged_pr_count: merged_pr_count,
        total_merge_time: total_merge_time,
        average_merge_time: average_merge_time,
        approval_count: approval_count
      )
      Rails.logger.debug { "statistic------ #{statistic.inspect}" }
    end
    # rubocop:enable Metrics/MethodLength, Metrics/AbcSize
  end
end
