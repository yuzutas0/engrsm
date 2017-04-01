# frozen_string_literal: true
# tale_finder
module TaleFinder
  extend ActiveSupport::Concern

  # -----------------------------------------------------------------
  # Const
  # -----------------------------------------------------------------
  DB_LIMIT_SIZE = 10
  ES_LIMIT_SIZE = 10_000
  QUERY = {
    user: 'tales.user_id = ?',
    tags: 'tags.user_id = ? AND tags.view_number IN (?)',
    keyword: '(tales.title LIKE ? OR tales.content LIKE ?)'
  }.freeze

  # -----------------------------------------------------------------
  # Methods
  # -----------------------------------------------------------------
  module ClassMethods
    # called by TaleRepository#list
    def index_by_db(user_id, tags, sort, page)
      condition = condition_for_db(user_id)
      read(condition, user_id, tags, sort, page)
    end

    # called by TaleRepository#search_by_db only when keywords are present
    def search_by_db(user_id, keywords, tags, sort, page)
      condition = condition_for_db(user_id)
      keywords.each do |keyword|
        keyword = '%' + keyword + '%'
        condition = condition.where(QUERY[:keyword], keyword, keyword)
      end
      read(condition, user_id, tags, sort, page)
    end

    # called by TaleRepository#search_by_es
    def search_by_es(user_id, keywords, tags, sort, page)
      condition = search_request(user_id, keywords).records
      read(condition, user_id, tags, sort, page)
    end

    # -----------------------------------------------------------------
    # Support
    # -----------------------------------------------------------------
    private

    # common logic
    def condition_for_db(user_id)
      Tale.where(QUERY[:user], user_id)
    end

    def read(condition, user_id, tags, sort, page)
      pre_read(condition, user_id, tags, sort)
        .distinct
        .page(page)
        .per(DB_LIMIT_SIZE)
        .includes(:tale_tag_relationships)
    end

    def pre_read(condition, user_id, tags, sort)
      custom_sort(
        condition_for_tag(
          condition,
          user_id,
          tags
        ),
        sort
      )
    end

    def condition_for_tag(condition, user_id, tags)
      return condition if tags.blank?
      condition
        .joins(:tags)
        .where(QUERY[:tags], user_id, tags)
    end

    # refs. SearchForm#sort_master
    def custom_sort(condition, sort)
      # param
      default_sort_master = SearchForm.sort_master
      default_sort(condition, default_sort_master, sort)
    end

    def default_sort(condition, sort_master, sort)
      sort = -1 * sort.to_i - 1
      condition.order(sort_master[sort])
    end

    # keyword search by elasticsearch
    # FIXME: kaminari, analyzer, has_child
    def search_request(user_id, keywords)
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
          bool: {
            must: keyword_queries
          }
        },
        filter: {
          term: {
            user_id: user_id
          }
        },
        sort: [
          {
            created_at: {
              order: 'desc'
            }
          }
        ],
        size: ES_LIMIT_SIZE
      )
    end
  end
end
