# frozen_string_literal: true

class User < ActiveRecord::Base
  has_many :ads
  scope :recent, -> { order('created_at DESC') }

  class << self
    # i think it shouldn't be a scope
    # I think such methods should be separated from model due to reasons:
    # it is complex sql with several tables involved
    #
    # not sure about method name
    def published_between_users(date_from:, date_to:, published_ads_counts: 1)
      # looks like published_ads_count field breaks 3rd NF, coz it can be counted(it is assumption).
      # ofc it can be on purpose.
      return nil unless date_from.present? || date_to.present?

      recent.joins(:ads).group('ads.user_id').where(published_ads_count: published_ads_counts)
            .where(published_at: Date.parse(date_from)..Date.parse(date_to))
    end
  end
end
