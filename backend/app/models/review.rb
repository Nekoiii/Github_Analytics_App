class Review < ApplicationRecord
  belongs_to :pull_request
  belongs_to :author, class_name: 'User', inverse_of: :authored_reviews

  REVIEW_STATES = { pending: 0, approved: 1, rejected: 2, changes_requested: 3, dismissed: 4 }.freeze

  enum state: REVIEW_STATES

  class << self
    def update_or_create(reviews, pr_id)
      Rails.logger.debug { "Review--update_or_create---reviews-: #{reviews} ---pr_id-: #{pr_id}" }

      reviews.each do |review|
        author = User.find_or_create_by(github_login: review.dig('author', 'login'))

        review = Review.find_or_initialize_by(
          author_id: author.id,
          pull_request_id: pr_id
        )
        review.state = REVIEW_STATES[review['state']&.downcase&.to_sym]
        review.save!
      end
    end
  end
end
