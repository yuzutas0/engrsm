# frozen_string_literal: true
# comment_factory
class CommentFactory
  # -----------------------------------------------------------------
  # Create
  # -----------------------------------------------------------------
  # use transaction to save record if you call this method
  def self.instance(params, post)
    post.comments.build(params)
  end
end
