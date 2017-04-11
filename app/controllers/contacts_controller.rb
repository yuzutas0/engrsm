# frozen_string_literal: true
#
# ContactsController
#
class ContactsController < ApplicationController
  # -----------------------------------------------------------------
  # const
  # -----------------------------------------------------------------
  ENDPOINTS = [:create].freeze

  # -----------------------------------------------------------------
  # filter
  # -----------------------------------------------------------------
  skip_before_action :authenticate_user!, only: ENDPOINTS

  # -----------------------------------------------------------------
  # endpoint - create
  # -----------------------------------------------------------------
  # POST /contact
  def create
    @contact = Contact.new(contact_params)
    @contact.user_id = current_user.id if current_user
    @contact.request = request.headers.env.reject { |content|
      content.inspect.include?('rack') ||
        content.inspect.include?('action_dispatch') ||
        content.inspect.include?('warden') ||
        content.inspect.include?('SERVER') ||
        content.inspect.include?('COOKIE') ||
        content.inspect.include?('cookie') ||
        content.inspect.include?('session') ||
        content.inspect.include?('instance')
    }.inspect

    if @contact.save
      flash[:notice] = t('views.message.create.success')
    else
      flash[:alert] = ContactDecorator.flash(@contact, flash)
    end
    redirect_to :back
  end

  # -----------------------------------------------------------------
  # support methods
  # -----------------------------------------------------------------
  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def contact_params
    params.require(:contact).permit(:content)
  end
end
