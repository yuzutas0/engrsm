# frozen_string_literal: true
#
# PostsController
#
class PostsController < ApplicationController
  # -----------------------------------------------------------------
  # filter
  # -----------------------------------------------------------------
  before_action :set_own_post, only: [:edit, :update, :destroy]
  before_action :set_other_post, only: [:show]

  # -----------------------------------------------------------------
  # endpoint - create
  # -----------------------------------------------------------------
  # GET /posts/new
  def new
    block_double_post
    redirect_to posts_path, alert: t('views.message.validate.limit') unless PostService.validate(current_user.id)
    @post = PostService.new
    ready_form(@post)
  end

  # POST /posts
  def create
    @post, success = PostService.create(post_params, option_form_params, current_user)
    if success
      redirect_to @post, notice: t('views.message.create.success')
    else
      flash.now[:alert] = PostDecorator.flash(@post, flash)
      ready_form(@post, tags_params_string)
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
    @posts, @comments_attached = PostService.list(@queries)
    @tags, @tags_attached = TagService.list
    @default_sort_master = SearchForm.sort_master
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
    ready_form(@post)
  end

  # PATCH/PUT /posts/1
  def update
    @post, success = PostService.update(@post, post_params, option_form_params)
    if success
      redirect_to @post, notice: t('views.message.update.success')
    else
      flash.now[:alert] = PostDecorator.flash(@post, flash)
      ready_form(@post, tags_params_string)
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
  # validation
  # -----------------------------------------------------------------
  def block_double_post
    post = Post.where(user_id: current_user.id).first # FIXME: call service -> repository
    redirect_to edit_post_url(post) if post
  end

  # -----------------------------------------------------------------
  # for filter
  # -----------------------------------------------------------------
  # Use callbacks to share common setup or constraints between actions.
  def set_own_post
    @post = PostService.detail(params[:id], current_user.id)
    routing_error if @post.blank?
  end

  def set_other_post
    @post = PostService.detail_with_options(params[:id])
    routing_error if @post.blank?
  end

  # set some params for post form
  def ready_form(post, showing_tags = '')
    @form = PostDecorator.option_form(post, showing_tags)
    @tags = TagService.name_and_attached_count
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
