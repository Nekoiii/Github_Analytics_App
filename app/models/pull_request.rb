class PullRequest < ApplicationRecord
  belongs_to :repository
  # class_name: specifies the actual model name for the "merged_by" association.
  # Without class_name, Rails would try to find a model named "MergedBy".
  # *Don't forget to use 'optional: true' here!!!!
  belongs_to :author, class_name: 'User', optional: true
  belongs_to :merger, class_name: 'User', optional: true
  has_many :reviews, dependent: :destroy

  class << self
    def update_from_fetched_github_data(data, repo)
      Rails.logger.debug { "PullRequest-update_from_fetched_github_data--data---: #{data}" }

      pr = repo.pull_requests.find_or_initialize_by(github_id: data['id'])
      pr = update_pr(pr, data)

      reviews = data['reviews']
      update_review(reviews, pr.id) if reviews.present?

      Rails.logger.debug { "PullRequest-update_from_fetched_github_data--pr---: #{pr.inspect}" }
      pr
    end

    private

    
    # *unfinished: Organization/User
    def update_pr(pull_request, data)
      # *unfinished: need to be refined. (Now it can't find author or merger if that user not in collaborators.)
      author = User.find_by(github_login: data['author']['login'])
      merger = User.find_by(github_login: data['mergedBy']['login']) if data['mergedBy']
      updated_attributes = build_updated_attributes(data, author, merger)

      pull_request.update!(
        updated_attributes
      )
      pull_request
    end

    # rubocop:disable Metrics/MethodLength
    def build_updated_attributes(data, author, merger)
      same_attributes = data.slice('title', 'permalink', 'number', 'closed', 'merged').transform_keys(&:to_sym)
      {
        author_id: author&.id,
        merger_id: merger&.id,
        base_ref_name: data['baseRefName'],
        base_ref_oid: data['baseRefOid'],
        head_ref_name: data['headRefName'],
        head_ref_oid: data['headRefOid'],
        merge_commit: data.dig('mergeCommit', 'message'),
        is_draft: data['isDraft'],
        merged_at: data['mergedAt'],
        closed_at: data['closedAt'],
        github_created_at: data['createdAt'],
        github_updated_at: data['updatedAt'],
        github_published_at: data['publishedAt']
      }.merge!(same_attributes)
    end
    # rubocop:enable Metrics/MethodLength

    def update_review(reviews, pr_id)
      Review.update_or_create(reviews, pr_id)
    end
  end
end
