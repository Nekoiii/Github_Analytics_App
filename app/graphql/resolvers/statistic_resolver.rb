require 'date'

module Resolvers
  class StatisticResolver < GraphQL::Schema::Resolver
    type [Types::StatisticType], null: true

    argument :repository_id, ID, required: false
    argument :repository_name, String, required: false
    argument :repository_owner, String, required: false
    argument :from_date, GraphQL::Types::ISO8601Date, required: false
    argument :to_date, GraphQL::Types::ISO8601Date, required: false

    def resolve(repository_id: nil, repository_name: nil, repository_owner: nil, from_date: nil, to_date: nil)
      statistics = Statistic.statistics_during_date(repository_id, from_date, to_date) if repository_id
      if repository_name && repository_owner
        repo = Repository.repo_by_name_and_owner(repository_name, repository_owner)
        return if repo.blank?

        statistics = Statistic.statistics_during_date(repo[:id], from_date, to_date)
      end

      Rails.logger.debug { "StatisticResolver--statistics: #{statistics.inspect}" }
      process_statistics(statistics)
    end

    private

    def calcul_group(group)
      total_merge_time = group.pluck(:total_merge_time).compact.sum
      merged_pr_count = group.pluck(:merged_pr_count).compact.sum
      approval_count = group.pluck(:approval_count).compact.sum
      average_merge_time = total_merge_time / merged_pr_count

      [total_merge_time, merged_pr_count, approval_count, average_merge_time]
    end

    def update_cluster_stat_attrs(cluster_stat, group)
      total_merge_time, merged_pr_count, approval_count, average_merge_time = calcul_group(group)

      user_id = cluster_stat[:user_id]
      user = User.select(:id, :github_login, :avatar_url).order(:id).find(user_id) if user_id

      cluster_stat.merge!({ merged_pr_count: merged_pr_count,
                            total_merge_time: total_merge_time,
                            approval_count: approval_count,
                            average_merge_time: average_merge_time,
                            user: user })
    end

    def make_cluster_stat(group)
      first_stat = group[0]
      cluster_stat = first_stat.slice(:is_overall, :user_id)

      update_cluster_stat_attrs(cluster_stat, group)
      Rails.logger.debug "cluster_stat--xxx---: #{cluster_stat}"
      cluster_stat
    end

    def cluster_statistics(statistics_groups)
      cluster_stats = []
      statistics_groups.each do |group|
        cluster_stat = make_cluster_stat(group)
        Rails.logger.debug { "cluster_statistics--cluster_stats: #{cluster_stats}" }

        cluster_stats.push(cluster_stat) if cluster_stat.present?
      end

      cluster_stats
    end

    def process_statistics(statistics)
      statistics_groups_hash = statistics.group_by do |stat|
        [stat.is_overall, stat.user_id]
      end
      statistics_groups = statistics_groups_hash.values

      cluster_stats = cluster_statistics(statistics_groups)
      Rails.logger.debug { "process_statistics--cluster_stats: #{cluster_stats}" }

      cluster_stats
    end
  end
end
