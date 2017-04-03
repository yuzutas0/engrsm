# frozen_string_literal: true
#
# Post
#
class Post < ActiveRecord::Base
  # -----------------------------------------------------------------
  # relation
  # -----------------------------------------------------------------
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :post_tag_relationships, dependent: :delete_all
  has_many :tags, through: :post_tag_relationships

  # -----------------------------------------------------------------
  # validation
  # -----------------------------------------------------------------
  validates :title, presence: true, length: { minimum: 1, maximum: 255 }
  validates :content, presence: true, length: { minimum: 1, maximum: 15_000 }
  validates :user, presence: true

  # -----------------------------------------------------------------
  # elasticsearch
  # -----------------------------------------------------------------
  # include
  include PostSearchable
  include PostFinder
  # connect
  index_name PostSearchable::INDEX_NAME
  __elasticsearch__.client = PostSearchable::CLIENT

  # -----------------------------------------------------------------
  # pagination
  # -----------------------------------------------------------------
  paginates_per 10
end
