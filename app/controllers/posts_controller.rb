# frozen_string_literal: true
#
# PostsController
#
class PostsController < ApplicationController
  # -----------------------------------------------------------------
  # filter
  # -----------------------------------------------------------------
  before_action :set_post, only: [:edit, :update, :destroy]
  before_action :set_post_with_options, only: [:show]

  # -----------------------------------------------------------------
  # endpoint - create
  # -----------------------------------------------------------------
  # GET /posts/new
  def new
    redirect_to posts_path, alert: t('views.message.validate.limit') unless PostService.validate(current_user.id)
    @post = PostService.new
    ready_form(@post, current_user.id)
  end

  # POST /posts
  def create
    @post, success = PostService.create(post_params, option_form_params, current_user)
    if success
      redirect_to @post, notice: t('views.message.create.success')
    else
      flash.now[:alert] = PostDecorator.flash(@post, flash)
      ready_form(@post, current_user.id, tags_params_string)
      render :new
    end
  end

  # -----------------------------------------------------------------
  # endpoint - read
  # -----------------------------------------------------------------

  # GET /posts
  #
  # *** attention ***
  # combine posts.post_tag_relationships with tag as necessary!
  # e.g. (tags.select { |tag| tag.id == relation.tag_id })[0].name
  # because avoid to throw query about tag records twice
  def index
    @queries = SearchForm.new(params, request.fullpath)
    @is_searched, @search_conditions = SearchConditionService.request(current_user, @queries)
    @posts, @comments_attached = PostService.list(current_user.id, @queries)
    @tags, @tags_attached = TagService.list(current_user.id)
    @default_sort_master = SearchForm.sort_master
    @compare_master = SearchForm.compare_master
  end

  # GET /posts/1
  def show
    @new_comment = Comment.new
    @tab_class = PostDecorator.tab(params)
  end

  # -----------------------------------------------------------------
  # endpoint - update
  # -----------------------------------------------------------------
  # GET /posts/1/edit
  def edit
    ready_form(@post, current_user.id)
  end

  # PATCH/PUT /posts/1
  def update
    @post, success = PostService.update(@post, post_params, option_form_params, current_user)
    if success
      redirect_to @post, notice: t('views.message.update.success')
    else
      flash.now[:alert] = PostDecorator.flash(@post, flash)
      ready_form(@post, current_user.id, tags_params_string)
      render :edit
    end
  end

  # -----------------------------------------------------------------
  # endpoint - delete
  # -----------------------------------------------------------------
  # DELETE /posts/1
  def destroy
    @post.destroy
    redirect_to posts_url, notice: t('views.message.destroy.success')
  end

  # -----------------------------------------------------------------
  # support methods
  # -----------------------------------------------------------------
  private

  # -----------------------------------------------------------------
  # for filter
  # -----------------------------------------------------------------
  # Use callbacks to share common setup or constraints between actions.
  def set_post
    @post = PostService.detail(params[:id], current_user.id)
    routing_error if @post.blank?
  end

  def set_post_with_options
    @post = PostService.detail_with_options(params[:id], current_user.id)
    routing_error if @post.blank?
  end

  # set some params for post form
  def ready_form(post, user_id, showing_tags = '')
    @form = PostDecorator.option_form(post, showing_tags)
    @tags = TagService.name_and_attached_count(user_id)
  end

  # -----------------------------------------------------------------
  # for strong parameter
  # -----------------------------------------------------------------
  # Never trust parameters from the scary internet, only allow the white list through.
  def post_params
    params.require(:post).permit(:title, :content)
  end

  def tags_params_string
    params.require(:form).permit(:tags)[:tags]
  end

  # Get option form
  def option_form_params
    option_form = params.require(:form).permit(:tags)
    PostForm.new(tags: option_form[:tags]).form_to_object
  end
end
