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
  # routing path
  # -----------------------------------------------------------------
  # needs three params with request
  # user.id, post.view_number, comment.view_number
  # (user.id + post.view_number => post.id) + (comment.view_number) => comment.id

  # -----------------------------------------------------------------
  # validation
  # -----------------------------------------------------------------
  validates :content, presence: true, length: { minimum: 1, maximum: 15_000 }
  validates :view_number, presence: true, uniqueness: { scope: [:post_id] }
  validates :post, presence: true
end
