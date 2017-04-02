# frozen_string_literal: true
#
# Association
#
class PostTagRelationship < ActiveRecord::Base
  # -----------------------------------------------------------------
  # relation
  # -----------------------------------------------------------------
  belongs_to :post
  belongs_to :tag
  accepts_nested_attributes_for :post

  # -----------------------------------------------------------------
  # validation
  # -----------------------------------------------------------------
  validates :post_id, presence: true, uniqueness: { scope: [:tag_id] }
  validates :post, presence: true
  validates :tag, presence: true
end
