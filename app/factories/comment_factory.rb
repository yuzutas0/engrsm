# frozen_string_literal: true
# comment_factory
class CommentFactory
  # -----------------------------------------------------------------
  # Create
  # -----------------------------------------------------------------

  # use transaction to save record if you call this method
  # in order to make combination of tale_id and view_number unique
  def self.instance(params, tale)
    comment = tale.comments.build(params)
    comment.view_number = increment_view_number(tale.id)
    comment
  end

  # support method
  def self.increment_view_number(tale_id)
    last = Comment.where('tale_id = ?', tale_id).maximum(:view_number)
    last.present? ? last + 1 : 1
  end
end
