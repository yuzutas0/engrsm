# frozen_string_literal: true
#
# Comment
#
class Comment < ActiveRecord::Base
  # -----------------------------------------------------------------
  # relation
  # -----------------------------------------------------------------
  belongs_to :tale

  # -----------------------------------------------------------------
  # routing path
  # -----------------------------------------------------------------
  # needs three params with request
  # user.id, tale.view_number, comment.view_number
  # (user.id + tale.view_number => tale.id) + (comment.view_number) => comment.id

  # -----------------------------------------------------------------
  # validation
  # -----------------------------------------------------------------
  validates :content, presence: true, length: { minimum: 1, maximum: 15_000 }
  validates :view_number, presence: true, uniqueness: { scope: [:tale_id] }
  validates :tale, presence: true
end
