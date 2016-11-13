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
    scores: '(scores.user_id = ? AND scores.key_name = ? AND scores.value ',
    keyword: '(tales.title LIKE ? OR tales.content LIKE ?)'
  }.freeze

  # -----------------------------------------------------------------
  # Methods
  # -----------------------------------------------------------------
  module ClassMethods
    # called by TaleRepository#list
    def index_by_db(user_id, tags, scores, sort, page)
      condition = condition_for_db(user_id)
      read(condition, user_id, tags, scores, sort, page)
    end

    # called by TaleRepository#search_by_db only when keywords are present
    def search_by_db(user_id, keywords, tags, scores, sort, page)
      condition = condition_for_db(user_id)
      keywords.each do |keyword|
        keyword = '%' + keyword + '%'
        condition = condition.where(QUERY[:keyword], keyword, keyword)
      end
      read(condition, user_id, tags, scores, sort, page)
    end

    # called by TaleRepository#search_by_es
    def search_by_es(user_id, keywords, tags, scores, sort, page)
      condition = search_request(user_id, keywords).records
      read(condition, user_id, tags, scores, sort, page)
    end

    # -----------------------------------------------------------------
    # Support
    # -----------------------------------------------------------------
    private

    # common logic
    def condition_for_db(user_id)
      Tale.where(QUERY[:user], user_id)
    end

    def read(condition, user_id, tags, scores, sort, page)
      pre_read(condition, user_id, tags, scores, sort)
        .distinct
        .page(page)
        .per(DB_LIMIT_SIZE)
        .includes(:tale_tag_relationships)
        .includes(:tags)
        .includes(:tale_score_relationships)
        .includes(:scores)
    end

    def pre_read(condition, user_id, tags, scores, sort)
      custom_sort(
        condition_for_score(
          condition_for_tag(
            condition,
            user_id,
            tags
          ),
          user_id,
          scores
        ),
        ScoreService.sort_master(user_id),
        sort
      )
    end

    def condition_for_tag(condition, user_id, tags)
      return condition if tags.blank?
      condition
        .joins(:tags)
        .where(QUERY[:tags], user_id, tags)
    end

    def condition_for_score(condition, user_id, scores)
      return condition if scores.blank?
      args = ['']
      scores[:key].each do |key|
        query, val = extract_score(scores, key)
        args[0] += ' OR ' if args[0].present?
        args[0] += query
        args += [user_id, key, val]
      end
      condition.joins(:scores).where(args)
    end

    def extract_score(scores, key)
      co = (scores[:co].find { |item| item.split(':', 2)[0] == key }).split(':', 2)[1]
      query = QUERY[:scores] + SearchForm.compare_to_query(co) + ' ?)'
      val = (scores[:val].find { |item| item.split(':', 2)[0] == key }).split(':', 2)[1]
      [query, val]
    end

    # refs. SearchForm#sort_master or ScoreService#sort_master
    def custom_sort(condition, score_sort_master, sort)
      # param
      origin_sort_master = SearchForm.sort_master
      sort = 0 unless 0 <= sort && sort < (origin_sort_master + score_sort_master).length
      # order by
      if sort < origin_sort_master.length
        origin_sort(condition, origin_sort_master, sort)
      else
        score_sort(condition, score_sort_master, sort - origin_sort_master.length)
      end
    end

    def origin_sort(condition, sort_master, sort)
      condition.order(sort_master[sort])
    end

    def score_sort(condition, sort_master, sort)
      order = sort_master[sort]
      key = order.keys.first.to_s
      value = order.values.first.to_s
      condition
        .joins('LEFT OUTER JOIN `tale_score_relationships` ON `tale_score_relationships`.`tale_id` = `tales`.`id`')
        .joins('LEFT OUTER JOIN `scores` ON `scores`.`id` = `tale_score_relationships`.`score_id`')
        .order("(CASE WHEN scores.key_name = '#{key}' THEN scores.value ELSE '' END) #{value}")
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
