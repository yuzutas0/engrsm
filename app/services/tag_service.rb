# frozen_string_literal: true
# tag_service
class TagService
  # -----------------------------------------------------------------
  # Create, Update
  # -----------------------------------------------------------------

  # *** use transaction ***
  # change tags and relation between post and tags
  def self.change_tags(post_id, tags)
    TagFactory.create_only_new_name(tags)
    PostTagRelationshipService.update(post_id, tags)
  end

  # -----------------------------------------------------------------
  # Update
  # -----------------------------------------------------------------

  # called by TagsController#update
  # one request can update only one column
  def self.update(tag, params)
    TagRepository.update(tag, PostForm.escape(params[:name]))
  end

  # -----------------------------------------------------------------
  # Read
  # -----------------------------------------------------------------

  # called TagsController#index, PostsController#index
  # [tags, tags_attached]
  def self.list
    tags = TagRepository.list
    tags_attached = TagRepository.id_and_attached_count
    [tags, tags_attached]
  end

  # called by TagsController#set_tag to throw query about tag
  def self.detail(id)
    TagRepository.detail(id)
  end

  # called by PostController#ready_form to show suggestion
  def self.name_and_attached_count
    TagRepository.name_and_attached_count
  end
end
