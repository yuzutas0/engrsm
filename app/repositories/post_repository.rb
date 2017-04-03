# frozen_string_literal: true
# post_repository
class PostRepository
  # -----------------------------------------------------------------
  # Read - index
  # -----------------------------------------------------------------

  # get index by MariaDB
  def self.list(user_id: nil, tags: nil, sort: nil, page: nil)
    Post.index_by_db(user_id, tags, sort, page)
  end

  # search by MariaDB
  def self.search_by_db(user_id: nil, keywords: nil, tags: nil, sort: nil, page: nil)
    Post.search_by_db(user_id, keywords, tags, sort, page)
  end

  # search by Elasticsearch
  def self.search_by_es(user_id: nil, keywords: nil, tags: nil, sort: nil, page: nil)
    Post.search_by_es(user_id, keywords, tags, sort, page)
  end

  # get all records
  def self.all(user_id)
    Post.where(user_id: user_id)
        .includes(:comments, :tags)
        .merge(Comment.order('comments.created_at DESC'))
        .merge(Tag.order('tags.id DESC'))
  end

  # count records
  def self.count(user_id)
    Post.where(user_id: user_id).count
  end

  # -----------------------------------------------------------------
  # Read - detail
  # -----------------------------------------------------------------

  # without options
  def self.detail(id, user_id)
    Post.where('id = ? AND user_id = ?', id, user_id).first
  end

  # with options
  def self.detail_with_options(id, user_id)
    Post.where('id = ? AND user_id = ?', id, user_id)
        .includes(:tags)
        .includes(:comments)
        .first
  end
end
