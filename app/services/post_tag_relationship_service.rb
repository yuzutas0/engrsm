# frozen_string_literal: true
# post_tag_relationship_service
class PostTagRelationshipService
  # -----------------------------------------------------------------
  # Update
  # -----------------------------------------------------------------

  # *** use transaction ***
  # update records by delete old relation and create new relation
  def self.update(post_id, tag_name_list)
    PostTagRelationshipRepository.delete_by_post_id(post_id)
    PostTagRelationshipFactory.create_by_tag_name_list(post_id, tag_name_list)
  end
end
