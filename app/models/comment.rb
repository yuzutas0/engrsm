# frozen_string_literal: true
#
# Comment
#
class Comment < ActiveRecord::Base
  # -----------------------------------------------------------------
  # relation
  # -----------------------------------------------------------------
  belongs_to :post

  # -----------------------------------------------------------------
  # validation
  # -----------------------------------------------------------------
  validates :content, presence: true, length: { minimum: 1, maximum: 15_000 }
  validates :post, presence: true
end
