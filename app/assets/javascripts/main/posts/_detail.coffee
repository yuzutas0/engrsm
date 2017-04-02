# posts/detail
@engrsm_posts_detail = ->

  # const
  DETAIL_ID = 'script__post__detail'

  TAB_BUTTON_PREFIX = '#script__post__detail__tab'
  TAB_BUTTONS = [
    TAB_BUTTON_PREFIX + 1,
    TAB_BUTTON_PREFIX + 2,
    TAB_BUTTON_PREFIX + 3
  ]

  TAB_QUERY_PREFIX = '?'
  TAB_QUERY_SUFFIX = '=selected'
  TAB_QUERIES = [
    TAB_QUERY_PREFIX + 'content' + TAB_QUERY_SUFFIX,
    TAB_QUERY_PREFIX + 'information' + TAB_QUERY_SUFFIX,
    TAB_QUERY_PREFIX + 'comments' + TAB_QUERY_SUFFIX
  ]

  # check DOM
  if document.getElementById(DETAIL_ID) != null
    EngrsmUtilTab.rewriteQuery(TAB_BUTTONS, TAB_QUERIES)
