# frozen_string_literal: true
# search form
class SearchForm
  attr_accessor :page, :keyword, :tags, :sort, :save, :name, :query_string

  DEFAULT_PAGE = 1
  DEFAULT_KEYWORD = nil
  DEFAULT_TAGS = [].freeze
  DEFAULT_SORT = -1.to_s

  # -----------------------------------------------------------------
  # Constructor
  # -----------------------------------------------------------------
  def initialize(params = {}, request_path = '')
    # for search
    @page = params[:page] || DEFAULT_PAGE
    @keyword = params[:keyword].present? ? params[:keyword].html_safe : DEFAULT_KEYWORD
    @tags = valid_tags?(params[:tags]) ? convert_tags(params[:tags]) : DEFAULT_TAGS
    @sort = valid_sort?(params[:sort]) ? params[:sort] : DEFAULT_SORT
    # for save
    @save = params[:save] == true.to_s
    @name = params[:name].html_safe if params[:name].present?
    @query_string = request_path.include?('?') ? convert_query_string : ''
  end

  # -----------------------------------------------------------------
  # Master Enum
  # -----------------------------------------------------------------

  # refs. config/locales/defaults/en.yml
  # -1: Newer Create - t('master.sort.option_0')
  # -2: Older Create - t('master.sort.option_1')
  # -3: Newer Update - t('master.sort.option_2')
  # -4: Older Update - t('master.sort.option_3')
  def self.sort_master
    [
      { created_at: :desc }, # -1
      { created_at: :asc  }, # -2
      { updated_at: :desc }, # -3
      { updated_at: :asc  }, # -4
    ]
  end

  # -----------------------------------------------------------------
  # Support - validator, converter
  # -----------------------------------------------------------------
  private

  def valid_tags?(tags)
    tags.present? && tags[:id].is_a?(Array)
  end

  def convert_tags(tags)
    tags[:id].map(&:to_i)
  end

  def array_of(hash_array)
    hash_array.map { |hash| hash.keys.first.to_s }
  end

  def divided(item)
    item.split(':', 2)
  end

  def valid_sort?(sort)
    value_range = [*(-1 * self.class.sort_master.length...0)].map(&:to_s)
    sort.present? && value_range.include?(sort.to_s)
  end

  def convert_query_string
    query = ''
    query = add_query(query, 'keyword', @keyword) unless @keyword == DEFAULT_KEYWORD
    @tags.each { |tag| query = add_query(query, 'tags[id][]', tag.to_s) } unless @tags == DEFAULT_TAGS
    query = add_query(query, 'sort', @sort.to_s) unless @sort == DEFAULT_SORT
    query
  end

  def add_query(query, key, value)
    query += '&' if query.present?
    query + key + '=' + value
  end
end
