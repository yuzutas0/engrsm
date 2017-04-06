# frozen_string_literal: true
# comment_factory
class CommentFactory
  # -----------------------------------------------------------------
  # Create
  # -----------------------------------------------------------------
  # use transaction to save record if you call this method
  def self.instance(params, post, user_id)
    post = post.comments.build(params)
    post.user_id = user_id
    post
  end
end
