# frozen_string_literal: true
#
# Comment
#
class Comment < ActiveRecord::Base
  # -----------------------------------------------------------------
  # relation
  # -----------------------------------------------------------------
  belongs_to :post
  belongs_to :user

  # -----------------------------------------------------------------
  # validation
  # -----------------------------------------------------------------
  validates :content, presence: true, length: { minimum: 1, maximum: 15_000 }
  validates :post, presence: true
  validates :user, presence: true
end
