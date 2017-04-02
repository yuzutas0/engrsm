# frozen_string_literal: true
# post_tag_relationship_repository
class PostTagRelationshipRepository
  # -----------------------------------------------------------------
  # Delete
  # -----------------------------------------------------------------

  # DELETE FROM post_tag_relationships WHERE post_id = #{post_id}
  def self.delete_by_post_id(post_id)
    PostTagRelationship.where('post_id = ?', post_id).delete_all
  end
end
