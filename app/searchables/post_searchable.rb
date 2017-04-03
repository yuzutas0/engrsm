# frozen_string_literal: true
# searchables/post_searchable.rb
module PostSearchable
  extend ActiveSupport::Concern
  include ApplicationSearchable

  included do
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks

    # mapping
    mapping dynamic: 'false' do
      indexes :id,          type: 'integer', index: 'not_analyzed'
      indexes :title,       type: 'string',  index: 'analyzed', analyzer: 'kuromoji_analyzer'
      indexes :content,     type: 'string',  index: 'analyzed', analyzer: 'kuromoji_analyzer'
      indexes :user_id,     type: 'integer', index: 'not_analyzed'
      indexes :created_at,  type: 'date',    index: 'not_analyzed', format: 'date_time'
      indexes :updated_at,  type: 'date',    index: 'not_analyzed', format: 'date_time'
    end
  end
end
