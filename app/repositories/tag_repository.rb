# frozen_string_literal: true
# tag_repository
class TagRepository
  # -----------------------------------------------------------------
  # Read
  # -----------------------------------------------------------------

  # SELECT * FROM tags
  def self.list
    Tag.all || []
  end

  # SELECT * FROM tags WHERE id = #{id}
  def self.detail(tag_id)
    Tag.where('id = ?', tag_id).first
  end

  # get hash about tag's id and how many posts the tag is attached to
  # => e.g. { 1: 21, 2: 15, 3: 23 }
  def self.id_and_attached_count
    # query
    query = <<-'SQL'
      SELECT
        T.id,
        COUNT(R.id)
      FROM
        tags T
      LEFT OUTER JOIN -- count for zero attached record
        post_tag_relationships R
      ON
        T.id = R.tag_id
      GROUP BY
        T.id
    SQL
    # execute
    CommonRepository.select_hash(query)
  end

  # get hash about tag's name and how many posts the tag is attached to
  # => { name: size, ... }
  # => e.g. { 'testOne': 21, 'test2': 15, 'test_three': 23 }
  def self.name_and_attached_count
    # query
    query = <<-'SQL'
      SELECT
        T.name,
        COUNT(R.id)
      FROM
        tags T
      LEFT OUTER JOIN -- count for zero attached record
        post_tag_relationships R
      ON
        T.id = R.tag_id
      GROUP BY
        T.id
    SQL
    # execute
    CommonRepository.select_hash(query)
  end

  # -----------------------------------------------------------------
  # Update
  # -----------------------------------------------------------------

  def self.update(tag, name)
    tag.update(name: name)
  end
end
