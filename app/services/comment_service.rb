# frozen_string_literal: true
# comment_service
class CommentService
  # -----------------------------------------------------------------
  # Create
  # -----------------------------------------------------------------

  def self.create(params, tale_view_number, user_id)
    Comment.transaction do
      tale = TaleRepository.detail(tale_view_number, user_id)
      comment = CommentFactory.instance(params, tale)
      success = comment.save
      return tale, comment, success
    end
  end

  # -----------------------------------------------------------------
  # Read - detail
  # -----------------------------------------------------------------

  def self.detail(user_id, tale_view_number, comment_view_number)
    TaleRepository.detail(tale_view_number, user_id)
                  .comments
                  .find_by(view_number: comment_view_number)
  end
end
