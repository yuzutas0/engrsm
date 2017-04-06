# frozen_string_literal: true
# post_finder
module PostFinder
  extend ActiveSupport::Concern

  # -----------------------------------------------------------------
  # Const
  # -----------------------------------------------------------------
  DB_LIMIT_SIZE = 10
  ES_LIMIT_SIZE = 10_000
  QUERY = {
    tags: 'tags.id IN (?)',
    keyword: '(posts.title LIKE ? OR posts.content LIKE ?)'
  }.freeze

  # -----------------------------------------------------------------
  # Methods
  # -----------------------------------------------------------------
  module ClassMethods
    # called by PostRepository#list
    def index_by_db(tags, sort, page)
      condition = Post.all
      read(condition, tags, sort, page)
    end

    # called by PostRepository#search_by_db only when keywords are present
    def search_by_db(keywords, tags, sort, page)
      condition = Post.all
      keywords.each do |keyword|
        keyword = '%' + keyword + '%'
        condition = condition.where(QUERY[:keyword], keyword, keyword)
      end
      read(condition, tags, sort, page)
    end

    # called by PostRepository#search_by_es
    def search_by_es(keywords, tags, sort, page)
      condition = search_request(keywords).records
      read(condition, tags, sort, page)
    end

    # -----------------------------------------------------------------
    # Support
    # -----------------------------------------------------------------
    private

    def read(condition, tags, sort, page)
      condition = condition_for_tag(condition, tags)
      custom_sort(condition, sort)
        .distinct
        .page(page)
        .per(DB_LIMIT_SIZE)
        .includes(:post_tag_relationships)
    end

    def condition_for_tag(condition, tags)
      return condition if tags.blank?
      condition
        .joins(:tags)
        .where(QUERY[:tags], tags)
    end

    # refs. SearchForm#sort_master
    def custom_sort(condition, sort)
      sort_master = SearchForm.sort_master
      sort = -1 * sort.to_i - 1
      condition.order(sort_master[sort])
    end

    # keyword search by elasticsearch
    # FIXME: kaminari, analyzer, has_child
    def search_request(keywords)
      keyword_queries = keywords.map do |keyword|
        {
          bool: {
            should: [
              { term: { title: keyword.downcase } },
              { term: { content: keyword.downcase } }
            ]
          }
        }
      end

      __elasticsearch__.search(
        query: {
          bool: { must: keyword_queries }
        },
        sort: [
          { created_at: { order: 'desc' } }
        ],
        size: ES_LIMIT_SIZE
      )
    end
  end
end
