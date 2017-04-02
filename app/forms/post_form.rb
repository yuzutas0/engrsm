# frozen_string_literal: true
# post form
class PostForm
  attr_reader :tags

  def initialize(params = {})
    @tags = self.class.escape(params[:tags])
  end

  # @tags = 'tag1,tag2'
  # => @tags = ['tag1','tag2']
  def form_to_object
    @tags = @tags.split(',').map(&:html_safe)
    self
  end

  # same as: javascripts/util/xss.coffee#escapeString
  def self.escape(tag = '')
    tag.gsub(%r{[&<>"'`=/]}, '').strip
  end
end
