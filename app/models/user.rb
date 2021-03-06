# frozen_string_literal: true
#
# User
#
class User < ActiveRecord::Base
  # -----------------------------------------------------------------
  # devise
  # -----------------------------------------------------------------
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable

  # -----------------------------------------------------------------
  # relation
  # -----------------------------------------------------------------
  has_many :search_conditions, dependent: :destroy
  has_one :post, dependent: :destroy
  has_many :contact

  # -----------------------------------------------------------------
  # validation
  # -----------------------------------------------------------------
  validates :name, presence: true, length: { minimum: 1, maximum: 255 }
  validates :timezone, presence: true, inclusion: { in: TZInfo::Timezone.all_identifiers }
end
