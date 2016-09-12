# tag_repository
class TagRepository
  # -----------------------------------------------------------------
  # Read
  # -----------------------------------------------------------------

  # SELECT * FROM tags WHERE user_id = #{user_id}
  def self.list(user_id)
    Tag.where('user_id = ?', user_id) || []
  end

  # SELECT * FROM tags WHERE user_id = #{user_id} AND view_number = #{view_number}
  def self.detail(user_id, view_number)
    Tag.where('user_id = ? AND view_number = ?', user_id, view_number).first
  end

  # get hash about tag's view_number and how many tales tag is attached to
  # => { view_number: size, ... }
  # => e.g. { 1: 21, 2: 15, 3: 23 }
  def self.view_number_and_attached_count(user_id)
    # query
    query = <<-'SQL'.freeze
      SELECT
        T.view_number,
        count(R.id) AS size
      FROM
        tags T
      LEFT OUTER JOIN -- count for zero attached record
        tale_tag_relationships R
      ON
        T.id = R.tag_id
      WHERE
        T.user_id = ?
      GROUP BY
        T.id
    SQL

    # execute
    select_hash_with_user_id(user_id, query)
  end

  # get hash about tag's name and how many tales tag is attached to
  # => { name: size, ... }
  # => e.g. { 'testOne': 21, 'test2': 15, ''test_three'': 23 }
  def self.name_and_attached_count(user_id)
    # query
    query = <<-'SQL'.freeze
      SELECT
        T.name,
        count(R.id) AS size
      FROM
        tags T
      LEFT OUTER JOIN -- count for zero attached record
        tale_tag_relationships R
      ON
        T.id = R.tag_id
      WHERE
        T.user_id = ?
      GROUP BY
        T.id
    SQL

    # execute
    select_hash_with_user_id(user_id, query)
  end

  # -----------------------------------------------------------------
  # Support
  # -----------------------------------------------------------------
  class << self
    private

    # execute query whose arg is user_id, and returns hash
    def select_hash_with_user_id(user_id, query)
      # validate
      return if user_id.blank?

      # execute
      args = [query, user_id]
      sql = ActiveRecord::Base.send(:sanitize_sql_array, args)
      result = ActiveRecord::Base.connection.execute(sql)

      # interface
      result.to_h || {}
    end
  end
end
