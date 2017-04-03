# frozen_string_literal: true
# tag_factory
class TagFactory
  # -----------------------------------------------------------------
  # Create
  # -----------------------------------------------------------------
  # *** use transaction ***
  # create only new tags
  def self.create_only_new_name(tag_name_list)
    return if tag_name_list.blank?
    only_new_name_list = diff_list(tag_name_list)
    records = []
    only_new_name_list.each { |new_name| records << Tag.new(name: new_name) }
    Tag.bulk_import(records)
  end

  # -----------------------------------------------------------------
  # Support
  # -----------------------------------------------------------------
  class << self
    private

    # get only new tags for the user without already exist tags
    def diff_list(tag_name_list)
      exist_list = Tag.all.pluck(:name)
      tag_name_list - exist_list
    end
  end
end
