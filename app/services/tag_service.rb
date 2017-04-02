# frozen_string_literal: true
# tag_service
class TagService
  # -----------------------------------------------------------------
  # Create, Update
  # -----------------------------------------------------------------

  # *** use transaction ***
  # change tags and relation between post and tags
  def self.change_tags(post_id, tags, user)
    TagFactory.create_only_new_name(user, tags)
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
  def self.list(user_id)
    tags = TagRepository.list(user_id)
    tags_attached = TagRepository.view_number_and_attached_count(user_id)
    [tags, tags_attached]
  end

  # called by TagsController#set_tag to throw query about tag
  def self.detail(user_id, view_number)
    TagRepository.detail(user_id, view_number)
  end

  # called by PostController#ready_form to show suggestion
  def self.name_and_attached_count(user_id)
    TagRepository.name_and_attached_count(user_id)
  end
end
