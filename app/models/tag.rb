# frozen_string_literal: true
#
# Tag
#
class Tag < ActiveRecord::Base
  # -----------------------------------------------------------------
  # relation
  # -----------------------------------------------------------------
  belongs_to :user
  has_many :post_tag_relationships, dependent: :delete_all
  has_many :posts, through: :post_tag_relationships

  # -----------------------------------------------------------------
  # validation
  # -----------------------------------------------------------------
  validates :name, presence: true, length: { minimum: 1, maximum: 100 }
  validates :user, presence: true
end
