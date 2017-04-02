# frozen_string_literal: true
# comment_service
class CommentService
  # -----------------------------------------------------------------
  # Create
  # -----------------------------------------------------------------

  def self.create(params, post_view_number, user_id)
    Comment.transaction do
      post = PostRepository.detail(post_view_number, user_id)
      comment = CommentFactory.instance(params, post)
      success = comment.save
      return post, comment, success
    end
  end

  # -----------------------------------------------------------------
  # Read - detail
  # -----------------------------------------------------------------

  def self.detail(user_id, post_view_number, comment_view_number)
    PostRepository.detail(post_view_number, user_id)
                  .comments
                  .find_by(view_number: comment_view_number)
  end
end
