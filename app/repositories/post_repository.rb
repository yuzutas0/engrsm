# frozen_string_literal: true
# post_repository
class PostRepository
  # -----------------------------------------------------------------
  # Read - index
  # -----------------------------------------------------------------

  # get index by MariaDB
  def self.list(tags: nil, sort: nil, page: nil)
    Post.index_by_db(tags, sort, page)
  end

  # search by MariaDB
  def self.search_by_db(keywords: nil, tags: nil, sort: nil, page: nil)
    Post.search_by_db(keywords, tags, sort, page)
  end

  # search by Elasticsearch
  def self.search_by_es(keywords: nil, tags: nil, sort: nil, page: nil)
    Post.search_by_es(keywords, tags, sort, page)
  end

  # count records
  def self.count(user_id)
    Post.where(user_id: user_id).count
  end

  # get all records for user with options
  def self.list_by_user_with_options(user_id)
    Post.where(user_id: user_id)
        .includes(:comments, :tags)
        .merge(Comment.order('comments.created_at DESC').includes(:user))
        .merge(Tag.order('tags.id DESC'))
  end

  # -----------------------------------------------------------------
  # Read - detail
  # -----------------------------------------------------------------

  def self.detail(id)
    Post.where('id = ?', id).first
  end

  def self.detail_by_user(user_id)
    Post.where('user_id = ?', user_id).first
  end

  # without options
  def self.detail_own(id, user_id)
    Post.where('id = ? AND user_id = ?', id, user_id).first
  end

  # with options
  def self.detail_with_options(id)
    Post.where(id: id)
        .includes(:tags, :comments, :user)
        .merge(Comment.order('comments.created_at DESC').includes(:user))
        .first
  end
end
