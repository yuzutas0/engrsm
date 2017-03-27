# frozen_string_literal: true
# sequel_decorator
class SequelDecorator < BaseDecorator
  # add flash message about error reasons
  def self.flash(sequel, flash)
    flash_for_redirect(sequel, flash)
  end
end
