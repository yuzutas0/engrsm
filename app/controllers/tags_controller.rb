# frozen_string_literal: true
#
# TagsController
#
class TagsController < ApplicationController
  # -----------------------------------------------------------------
  # filter
  # -----------------------------------------------------------------
  before_action :set_tag, only: [:update, :destroy]

  # -----------------------------------------------------------------
  # endpoint - read
  # -----------------------------------------------------------------
  # GET /tags
  def index
    @tags, @tags_attached = TagService.list
  end

  # -----------------------------------------------------------------
  # endpoint - update
  # -----------------------------------------------------------------
  # PATCH /tags/:id
  def update
    if TagService.update(@tag, tag_params)
      flash[:notice] = t('views.message.update.success')
    else
      flash[:alert] = TagDecorator.flash(@tag, flash)
    end
    redirect_to tags_url
  end

  # -----------------------------------------------------------------
  # endpoint - delete
  # -----------------------------------------------------------------
  # DELETE /tags/:id
  def destroy
    if @tag.destroy
      flash[:notice] = t('views.message.destroy.success')
    else
      flash[:alert] = TagDecorator.flash(@tag, flash)
    end
    redirect_to tags_url
  end

  # -----------------------------------------------------------------
  # support methods
  # -----------------------------------------------------------------
  private

  # Use callbacks to share common setup or constraints between actions.
  def set_tag
    @tag = TagService.detail(current_user.id, params[:id])
    routing_error if @tag.blank?
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def tag_params
    params.require(:tag).permit(:name, :id)
  end
end
