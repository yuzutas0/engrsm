# frozen_string_literal: true
# comment_factory
class CommentFactory
  # -----------------------------------------------------------------
  # Create
  # -----------------------------------------------------------------

  # use transaction to save record if you call this method
  # in order to make combination of post_id and view_number unique
  def self.instance(params, post)
    comment = post.comments.build(params)
    comment.view_number = increment_view_number(post.id)
    comment
  end

  # support method
  def self.increment_view_number(post_id)
    last = Comment.where('post_id = ?', post_id).maximum(:view_number)
    last.present? ? last + 1 : 1
  end
end
