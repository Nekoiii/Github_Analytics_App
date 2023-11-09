# frozen_string_literal: true

# BaseEnum: https://zenn.dev/nisitin/articles/ebb278cd92f69d
module Types
  class ReviewEnumType < BaseEnum
    Review::REVIEW_STATES.each_key do |key|
      value key.to_s.upcase, "A review of state #{key}", value: key.to_s
    end
  end
end
