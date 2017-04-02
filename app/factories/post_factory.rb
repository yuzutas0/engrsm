# frozen_string_literal: true
# post_factory
class PostFactory
  # -----------------------------------------------------------------
  # Create
  # -----------------------------------------------------------------

  # use transaction to save record if you call this method
  # in order to make combination of user_id and view_number unique
  def self.instance(params, user)
    post = Post.new(params)
    post.user = user
    post.view_number = increment_view_number(user.id)
    post
  end

  # support method
  def self.increment_view_number(user_id)
    last = Post.where('user_id = ?', user_id).maximum(:view_number)
    last.present? ? last + 1 : 1
  end
end
