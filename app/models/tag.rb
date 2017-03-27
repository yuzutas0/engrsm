# frozen_string_literal: true
#
# Tag
#
class Tag < ActiveRecord::Base
  # -----------------------------------------------------------------
  # relation
  # -----------------------------------------------------------------
  belongs_to :user
  has_many :tale_tag_relationships, dependent: :delete_all
  has_many :tales, through: :tale_tag_relationships

  # -----------------------------------------------------------------
  # routing path (tags/:id => tags/:view_number)
  # -----------------------------------------------------------------
  # needs two params with request
  # user.id, tag.view_number
  # (user.id + tag.view_number => tag.id)
  def to_param
    view_number.to_s
  end

  # -----------------------------------------------------------------
  # validation
  # -----------------------------------------------------------------
  validates :name,
            presence: true,
            length: { minimum: 1, maximum: 100 }

  validates :view_number,
            presence: true,
            uniqueness: { scope: [:user_id] },
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  validates :user,
            presence: true
end
