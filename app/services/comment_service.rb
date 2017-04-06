# frozen_string_literal: true
# comment_service
class CommentService
  # -----------------------------------------------------------------
  # Create
  # -----------------------------------------------------------------

  def self.create(params, post_id, user_id)
    Comment.transaction do
      post = PostRepository.detail(post_id)
      comment = CommentFactory.instance(params, post, user_id)
      success = comment.save
      return comment, success
    end
  end

  # -----------------------------------------------------------------
  # Read - detail
  # -----------------------------------------------------------------

  def self.detail(user_id, id)
    CommentRepository.detail(id, user_id)
  end
end
