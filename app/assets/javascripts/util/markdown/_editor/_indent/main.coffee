# indent - tab key
@engrsm_util_markdown_editor_indent = (e) ->

  # const
  KEY_CODE_TAB = 9

  # check key
  if e.keyCode == KEY_CODE_TAB
    e.preventDefault()

    if !e.shiftKey
      engrsm_util_markdown_editor_indent_add(e)
    if e.shiftKey
      engrsm_util_markdown_editor_indent_remove(e)
