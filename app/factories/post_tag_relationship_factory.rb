# frozen_string_literal: true
# post_tag_relationship_factory
class PostTagRelationshipFactory
  # -----------------------------------------------------------------
  # Create
  # -----------------------------------------------------------------

  # INSERT INTO post_tag_relationships (post_id, tag_id)
  # SELECT #{post_id}, T.id FROM tags T
  # WHERE T.name IN (#{tag_name_list[0]}, ..., #{tag_name_list[n]})
  def self.create_by_tag_name_list(post_id, tag_name_list)
    # validate
    return if tag_name_list.blank?

    # query
    query = <<-'SQL'
      INSERT INTO
          post_tag_relationships (
            post_id,
            tag_id
          )
        SELECT
            ?,
            T.id
        FROM
            tags T
        WHERE
            T.name IN (?)
    SQL

    # execute
    args = [query, post_id, tag_name_list]
    sql = ActiveRecord::Base.send(:sanitize_sql_array, args)
    ActiveRecord::Base.connection.execute(sql)
  end
end
