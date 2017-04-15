# frozen_string_literal: true
# post_decorator
class PostDecorator < BaseDecorator
  # -----------------------------------------------------------------
  # Common
  # -----------------------------------------------------------------

  # add flash message about error reasons
  def self.flash(post, flash)
    if post.errors.messages[:user]
      post.errors.add(:post, post.errors.messages[:user][0])
      post.errors.delete(:user)
    end
    flash_for_render(post, flash)
  end

  # -----------------------------------------------------------------
  # Show
  # -----------------------------------------------------------------

  # decide which tab is opened at first view
  # e.g. [ ['',''], ['',''], ['active','in active'] ]
  def self.tab(params)
    blank = ['', '']
    active = ['active', 'in active']
    result = [blank, blank, blank]
    if params[:comments].present?
      result[2] = active
    elsif params[:information].present?
      result[1] = active
    else
      result[0] = active
    end
    result
  end

  # -----------------------------------------------------------------
  # Form
  # -----------------------------------------------------------------

  # set option form
  def self.option_form(post, showing_tags = '')
    params = {}
    params[:tags] = post_tags_for_form(post, showing_tags)
    PostForm.new(params)
  end

  # -----------------------------------------------------------------
  # Support
  # -----------------------------------------------------------------
  class << self
    private

    def post_tags_for_form(post, showing_tags)
      # top priority
      return showing_tags if showing_tags.present?
      # set tags
      list = []
      list << post.tags.pluck(:name) if post.tags.present?
      list.join(',')
    end
  end
end
