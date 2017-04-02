# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  engrsm_posts_search()
  engrsm_posts_form()
  engrsm_posts_detail()

# execute with RubyGem 'turbolinks'
$(document).ready(ready)
$(document).on('page:load', ready)
