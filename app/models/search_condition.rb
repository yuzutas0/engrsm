# frozen_string_literal: true
#
# SearchCondition
#
class SearchCondition < ActiveRecord::Base
  # -----------------------------------------------------------------
  # relation
  # -----------------------------------------------------------------
  belongs_to :user

  # -----------------------------------------------------------------
  # validation
  # -----------------------------------------------------------------
  validates :name, length: { minimum: 0, maximum: 255 }
  validates :query_string, presence: true, length: { minimum: 1, maximum: 1_500 }
  validates :save_flag, inclusion: { in: [true, false] }
  validates :user, presence: true
end
