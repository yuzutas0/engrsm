# frozen_string_literal: true
#
# CommentsController
#
class CommentsController < ApplicationController
  # -----------------------------------------------------------------
  # filter
  # -----------------------------------------------------------------
  before_action :set_comment, only: [:update, :destroy]

  # -----------------------------------------------------------------
  # endpoint - create
  # -----------------------------------------------------------------
  # POST /comments
  def create
    @tale, @comment, success = CommentService.create(comment_params, params[:view_number], current_user.id)
    if success
      flash[:notice] = t('views.message.create.success')
    else
      flash[:alert] = CommentDecorator.flash(@comment, flash)
    end
    redirect_to "/tales/#{params[:view_number]}?comments=created"
  end

  # -----------------------------------------------------------------
  # endpoint - update
  # -----------------------------------------------------------------
  # PATCH /comments
  def update
    if @comment.update(comment_params)
      flash[:notice] = t('views.message.update.success')
    else
      flash[:alert] = CommentDecorator.flash(@comment, flash)
    end
    redirect_to "/tales/#{params[:view_number]}?comments=updated"
  end

  # -----------------------------------------------------------------
  # endpoint - delete
  # -----------------------------------------------------------------
  # DELETE /comments
  def destroy
    if @comment.destroy
      flash[:notice] = t('views.message.destroy.success')
    else
      flash[:alert] = CommentDecorator.flash(@comment, flash)
    end
    redirect_to "/tales/#{params[:view_number]}?comments=deleted"
  end

  # -----------------------------------------------------------------
  # support methods
  # -----------------------------------------------------------------
  private

  # Use callbacks to share common setup or constraints between actions.
  def set_comment
    @comment = CommentService.detail(current_user.id, params[:view_number], params[:comment_view_number])
    routing_error if @comment.blank?
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def comment_params
    params.require(:comment).permit(:content)
  end
end
