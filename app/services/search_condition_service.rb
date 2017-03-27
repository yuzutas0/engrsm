# frozen_string_literal: true
# search_condition_service
class SearchConditionService
  # -----------------------------------------------------------------
  # Create, Read, Update, Delete
  # -----------------------------------------------------------------
  # called by TaleService#list
  def self.request(user, search_form)
    # param
    save_flag, name, query_string = params_from_form(search_form)
    present_list = SearchConditionRepository.list(user.id)

    # validation
    return [false, present_list] if query_string.blank?

    # update or create
    add_history(user, query_string, present_list)
    add_saved(user, query_string, save_flag, name, present_list)

    # return all records
    [true, SearchConditionRepository.list(user.id)]
  end

  # -----------------------------------------------------------------
  # Read
  # -----------------------------------------------------------------
  def self.list(user_id)
    SearchConditionRepository.list(user_id)
  end

  def self.detail(user_id, view_number)
    SearchConditionRepository.detail(user_id, view_number)
  end

  # -----------------------------------------------------------------
  # Support
  # -----------------------------------------------------------------
  class << self
    private

    # get params value
    def params_from_form(search_form)
      save_flag = search_form.save
      name = search_form.name
      query_string = search_form.query_string
      [save_flag, name, query_string]
    end

    # logic for history (save_flag == false)
    def add_history(user, query_string, present_list)
      # get the records to be updated
      to_be_updated = (present_list.select do |item|
        !item.save_flag && item.query_string == query_string
      end).first

      # update or create
      if to_be_updated.present?
        SearchConditionRepository.update_time(to_be_updated)
      else
        present_size = present_list.reject(&:save_flag).length + 1
        create_and_delete(user, query_string, false, '', present_size)
      end
    end

    # logic for saved (save_flag == true)
    def add_saved(user, query_string, save_flag, name, present_list)
      return unless save_flag
      present_size = present_list.select(&:save_flag).length + 1
      create_and_delete(user, query_string, true, name, present_size)
    end

    # create new records & delete records to the specific size
    def create_and_delete(user, query_string, save_flag, name, present_size)
      SearchCondition.transaction do
        SearchConditionFactory.create(user, query_string, save_flag, name)
        SearchConditionRepository.delete_to_size(user.id, save_flag, present_size)
      end
    end
  end
end
