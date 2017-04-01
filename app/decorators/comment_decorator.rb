# frozen_string_literal: true
# comment_decorator
class CommentDecorator < BaseDecorator
  # add flash message about error reasons
  def self.flash(comment, flash)
    flash_for_redirect(comment, flash)
  end
end
