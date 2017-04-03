# frozen_string_literal: true
# comment_service
class CommentService
  # -----------------------------------------------------------------
  # Create
  # -----------------------------------------------------------------

  def self.create(params, id, user_id)
    Comment.transaction do
      post = PostRepository.detail(id, user_id)
      comment = CommentFactory.instance(params, post)
      success = comment.save
      return post, comment, success
    end
  end

  # -----------------------------------------------------------------
  # Read - detail
  # -----------------------------------------------------------------

  def self.detail(user_id, id)
    CommentRepository.detail(id, user_id)
  end
end
