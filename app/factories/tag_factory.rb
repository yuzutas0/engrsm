# frozen_string_literal: true
# tag_factory
class TagFactory
  # -----------------------------------------------------------------
  # Create
  # -----------------------------------------------------------------
  # *** use transaction ***
  # create only new tags for the user without already exist tags
  def self.create_only_new_name(user, tag_name_list)
    return if tag_name_list.blank?
    only_new_name_list = diff_list(user.id, tag_name_list)
    records = []
    only_new_name_list.each { |new_name| records << Tag.new(user: user, name: new_name) }
    Tag.bulk_import(records)
  end

  # -----------------------------------------------------------------
  # Support
  # -----------------------------------------------------------------
  class << self
    private

    # get only new tags for the user without already exist tags
    def diff_list(user_id, tag_name_list)
      exist_list = Tag.where('user_id = ?', user_id).pluck(:name)
      tag_name_list - exist_list
    end
  end
end
