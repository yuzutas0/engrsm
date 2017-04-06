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
  def self.detail_with_options(id)
    Post.where(id: id)
        .includes(:tags, :comments)
        .merge(Comment.order('comments.created_at DESC'))
        .first
  end
end
