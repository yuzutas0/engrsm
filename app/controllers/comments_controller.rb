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
    @post, @comment, success = CommentService.create(comment_params, params[:post_id], current_user.id)
    if success
      flash[:notice] = t('views.message.create.success')
    else
      flash[:alert] = CommentDecorator.flash(@comment, flash)
    end
    redirect_to "/posts/#{@post.id}?comments=created"
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
    redirect_to "/posts/#{params[:post_id]}?comments=updated"
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
    redirect_to "/posts/#{@comment.id}?comments=deleted"
  end

  # -----------------------------------------------------------------
  # support methods
  # -----------------------------------------------------------------
  private

  # Use callbacks to share common setup or constraints between actions.
  def set_comment
    @comment = CommentService.detail(current_user.id, params[:id])
    routing_error if @comment.blank?
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def comment_params
    params.require(:comment).permit(:id, :content)
  end
end
