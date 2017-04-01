# comments/form
@engrsm_comments_form = ->

  # loop for comment index length - 0 for new
  index = -1
  loop
    index++

    # DOM
    # const
    VUE_EDIT_ID = "script__comment__" + index
    VUE_EDIT_DOM = "#" + VUE_EDIT_ID
    # check
    break if document.getElementById(VUE_EDIT_ID) == null

    # switch
    # const
    VUE_MARKDOWN_DOM = '#script__comment__form__' + index
    SWITCH_MARKDOWN_EDITOR_DOM = VUE_MARKDOWN_DOM + "__editor__tab__switch"
    SWITCH_MARKDOWN_PREVIEW_DOM = VUE_MARKDOWN_DOM + "__preview__tab__switch"
    VUE_MARKDOWN_EDITOR_OUTER_DOM = VUE_MARKDOWN_DOM + "__editor__tab__content"
    VUE_MARKDOWN_PREVIEW_OUTER_DOM = VUE_MARKDOWN_DOM + "__preview__tab__content"
    HIDDEN_CLASS = 'hidden'
    # render
    EngrsmUtilTab.createTab(
      SWITCH_MARKDOWN_EDITOR_DOM,
      SWITCH_MARKDOWN_PREVIEW_DOM,
      VUE_MARKDOWN_EDITOR_OUTER_DOM,
      VUE_MARKDOWN_PREVIEW_OUTER_DOM,
      HIDDEN_CLASS
    )

    # markdown
    # const
    VUE_MARKDOWN_EDITOR_DOM = VUE_MARKDOWN_DOM + '__editor'
    VUE_MARKDOWN_PREVIEW_DOM = VUE_MARKDOWN_DOM + '__preview'
    # render
    editor = engrsm_util_markdown_editor(VUE_MARKDOWN_EDITOR_DOM)
    preview = EngrsmUtilMarkdownPreview.previewMarkdown(VUE_MARKDOWN_EDITOR_DOM, VUE_MARKDOWN_PREVIEW_DOM, VUE_MARKDOWN_DOM)

    # modal
    EngrsmUtilModal.createModal(VUE_EDIT_DOM, editor, preview)
