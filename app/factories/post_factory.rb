# frozen_string_literal: true
# post_factory
class PostFactory
  # -----------------------------------------------------------------
  # Create
  # -----------------------------------------------------------------
  # use transaction to save record if you call this method
  def self.instance(params, user)
    post = Post.new(params)
    post.user = user
    post
  end
end
