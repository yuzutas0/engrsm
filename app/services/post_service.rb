# frozen_string_literal: true
# post_service
class PostService
  # -----------------------------------------------------------------
  # Const
  # -----------------------------------------------------------------
  RECORDS_MAX_SIZE = 10_000

  # -----------------------------------------------------------------
  # Create
  # -----------------------------------------------------------------

  # validate new page
  def self.validate(user_id)
    PostRepository.count(user_id) < RECORDS_MAX_SIZE
  end

  # render page for create
  def self.new(user_name)
    post = Post.new
    post.title = 'About: ' + user_name
    post.tags = []
    post
  end

  # action to create
  def self.create(params, option_form, user)
    Post.transaction do
      post = PostFactory.instance(params, user)
      success = post.save
      change_records(post, option_form, success)
      return post, success
    end
  end

  # -----------------------------------------------------------------
  # Read - index
  # -----------------------------------------------------------------

  # return post list
  def self.list(queries)
    posts = search(queries)
    comments_attached = comments_attached(posts)
    [posts, comments_attached]
  end

  # -----------------------------------------------------------------
  # Read - detail
  # -----------------------------------------------------------------
  def self.detail_by_user(user_id)
    PostRepository.detail_by_user(user_id)
  end

  def self.detail_own(id, user_id)
    PostRepository.detail_own(id, user_id)
  end

  def self.detail_with_options(id)
    PostRepository.detail_with_options(id)
  end

  # -----------------------------------------------------------------
  # Update
  # -----------------------------------------------------------------
  def self.update(post, post_params, option_form)
    Post.transaction do
      success = post.update(post_params)
      change_records(post, option_form, success)
      return post, success
    end
  end

  # -----------------------------------------------------------------
  # Support
  # -----------------------------------------------------------------
  class << self
    private

    # -----------------------------------------------------------------
    # Create, Update
    # -----------------------------------------------------------------
    def change_records(post, option_form, success)
      return unless success
      TagService.change_tags(post.id, option_form.tags)
    end

    # -----------------------------------------------------------------
    # Read
    # -----------------------------------------------------------------

    # get list with keyword
    def search(queries)
      return PostRepository.list(search_args_without_keyword(queries)) if queries.keyword.blank?
      PostRepository.search_by_es(search_args_with_keyword(queries))
    rescue => e
      Rails.logger.warn "failure to request Elasticsearch: #{e.message}"
      PostRepository.search_by_db(search_args_with_keyword(queries))
    end

    def search_args_without_keyword(queries)
      {
        tags: queries.tags,
        sort: queries.sort,
        page: queries.page
      }
    end

    def search_args_with_keyword(queries)
      hash = search_args_without_keyword(queries)
      hash.merge(keywords: queries.keyword.split(/[[:blank:]]+/).reject(&:blank?).uniq)
    end

    def comments_attached(posts)
      post_id_list = posts.map(&:id)
      CommentRepository.post_id_and_attached_count(post_id_list)
    end
  end
end
