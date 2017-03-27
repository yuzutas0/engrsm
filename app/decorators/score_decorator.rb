# frozen_string_literal: true
# score_decorator
class ScoreDecorator < BaseDecorator
  # add flash message about error reasons
  def self.flash(score, flash)
    flash_for_redirect(score, flash)
  end
end
