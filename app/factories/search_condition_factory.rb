# frozen_string_literal: true
# search_condition_factory
class SearchConditionFactory
  # -----------------------------------------------------------------
  # Create
  # -----------------------------------------------------------------
  # use transaction to save record if you call this method
  def self.create(user, query_string, save_flag, name)
    name = save_flag && name.present? ? name : ''
    user.search_conditions.build(query_string: query_string, save_flag: save_flag, name: name).save
  end
end
