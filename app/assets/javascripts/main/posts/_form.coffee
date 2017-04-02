# posts/form
@engrsm_posts_form = ->

  # ---------------------------------------------------------------------
  # const and function
  # ---------------------------------------------------------------------

  # markdown preview
  VUE_MARKDOWN_ID = 'script__post'
  VUE_MARKDOWN_DOM = '#' + VUE_MARKDOWN_ID
  VUE_MARKDOWN_EDITOR_DOM = VUE_MARKDOWN_DOM + '__editor'
  VUE_MARKDOWN_PREVIEW_DOM = VUE_MARKDOWN_DOM + '__preview'

  # tab for mobile
  SWITCH_MARKDOWN_EDITOR_DOM = '#script__post__editor__tab__switch'
  SWITCH_MARKDOWN_PREVIEW_DOM = '#script__post__preview__tab__switch'
  VUE_MARKDOWN_EDITOR_OUTER_DOM = '#script__post__editor__tab__content'
  VUE_MARKDOWN_PREVIEW_OUTER_DOM = '#script__post__preview__tab__content'
  MOBILE_HIDDEN_CLASS = 'hidden-xs'

  # form suggest
  FORM_INPUT_ID = 'script__post__form__input'
  FORM_SUGGEST_ID = 'script__post__form__suggest'
  FORM_SUGGEST_OPTIONS_ID = 'script__post__form__suggest__options'
  FORM_INPUT_DOM = '#' + FORM_INPUT_ID

  # tag options text
  WHITE_SPACE = ' '
  TAG_OPTIONS_NAME = 0
  TAG_OPTIONS_SIZE = 1

  # ---------------------------------------------------------------------
  # logic for markdown
  # ---------------------------------------------------------------------
  # check DOM
  if document.getElementById(VUE_MARKDOWN_ID) != null

    # tab for mobile
    EngrsmUtilTab.createTab(
      SWITCH_MARKDOWN_EDITOR_DOM,
      SWITCH_MARKDOWN_PREVIEW_DOM,
      VUE_MARKDOWN_EDITOR_OUTER_DOM,
      VUE_MARKDOWN_PREVIEW_OUTER_DOM,
      MOBILE_HIDDEN_CLASS
    )

    # markdown preview
    engrsm_util_markdown_editor(VUE_MARKDOWN_EDITOR_DOM)
    EngrsmUtilMarkdownPreview.previewMarkdown(VUE_MARKDOWN_EDITOR_DOM, VUE_MARKDOWN_PREVIEW_DOM, VUE_MARKDOWN_DOM)

  # ---------------------------------------------------------------------
  # logic for tag
  # ---------------------------------------------------------------------
  # check DOM
  if document.getElementById(FORM_SUGGEST_OPTIONS_ID) != null

    # form suggest options
    suggestList = []
    index = -1
    while true

      # loop
      index++
      formSuggestOptionId = FORM_SUGGEST_OPTIONS_ID + '__' + index
      break if document.getElementById(formSuggestOptionId) == null

      # value
      option = EngrsmUtilXss.escapeString(document.getElementById(formSuggestOptionId).innerText).split(WHITE_SPACE)
      suggestion = { value: option[TAG_OPTIONS_NAME], countlist: option[TAG_OPTIONS_SIZE] }
      suggestList.push(suggestion)

    # set suggestion
    bloodhound = EngrsmUtilTagsinput.setSuggestion(suggestList)
    bloodhound.initialize

    # ready tag form
    templates = { suggestion: (data) -> return EngrsmTemplatePostForm.suggestion(data.value, data.countlist) }
    tagClass = EngrsmTemplatePostForm.tagClass()

    # set tag form
    EngrsmUtilTagsinput.setTagForm(FORM_INPUT_DOM, bloodhound, templates, tagClass)
    EngrsmUtilTagsinput.setCustomEvent(FORM_INPUT_DOM)
