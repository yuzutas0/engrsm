# frozen_string_literal: true
#
# Contact
#
class Contact < ActiveRecord::Base
  # -----------------------------------------------------------------
  # relation
  # -----------------------------------------------------------------
  belongs_to :user

  # -----------------------------------------------------------------
  # validation
  # -----------------------------------------------------------------
  validates :content, presence: true, length: { minimum: 1, maximum: 15_000 }
  validates :request, presence: true, length: { minimum: 1, maximum: 15_000 }
end
