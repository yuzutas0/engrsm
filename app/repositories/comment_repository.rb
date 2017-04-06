# frozen_string_literal: true
# comment_repository
class CommentRepository
  def self.detail(id, user_id)
    Comment.where('id = ? AND user_id = ?', id, user_id).first
  end

  # get hash about post_id and how many comments is posted to the post
  # => { post_id: size, ... }
  # => e.g. { 1: 15, 2: 0, 3: 4 }
  def self.post_id_and_attached_count(post_id_list)
    # query
    query = <<-'SQL'
      SELECT
        T.id,
        count(S.id) AS size
      FROM
        posts T
      LEFT OUTER JOIN -- count for zero attached record
        comments S
      ON
        T.id = S.post_id
      WHERE
        T.id IN (?)
      GROUP BY
        T.id
    SQL

    # execute
    args = [query, post_id_list]
    sql = ActiveRecord::Base.send(:sanitize_sql_array, args)
    ActiveRecord::Base.connection.execute(sql).to_h || {}
  end
end
