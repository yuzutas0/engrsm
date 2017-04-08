# frozen_string_literal: true
# contact_decorator
class ContactDecorator < BaseDecorator
  # add flash message about error reasons
  def self.flash(contact, flash)
    flash_for_redirect(contact, flash)
  end
end
