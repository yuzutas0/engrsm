# frozen_string_literal: true
# search_condition_repository
class SearchConditionRepository
  # -----------------------------------------------------------------
  # Read
  # -----------------------------------------------------------------
  def self.list(user_id)
    SearchCondition.where(user_id: user_id).order(updated_at: :desc)
  end

  def self.detail(user_id, view_number)
    SearchCondition.where(user_id: user_id, view_number: view_number).first
  end

  # -----------------------------------------------------------------
  # Update
  # -----------------------------------------------------------------
  def self.update_time(search_condition)
    search_condition.update_columns(updated_at: Time.now)
  end

  # -----------------------------------------------------------------
  # Delete
  # -----------------------------------------------------------------
  # the records count = 5 after this query
  def self.delete_to_size(user_id, save_flag, present_size)
    # validate
    delete_size = present_size - Constants::SEARCH_CONDITION_RECORD_SIZE
    return unless delete_size > 0
    # query
    query = <<-'SQL'
      DELETE
      FROM
        search_conditions
      WHERE
        user_id = ?
        AND save_flag = ?
      ORDER BY
        updated_at ASC
      LIMIT
        ?
    SQL
    # execute
    args = [query, user_id, save_flag, delete_size]
    sql = ActiveRecord::Base.send(:sanitize_sql_array, args)
    ActiveRecord::Base.connection.execute(sql)
  end
end
