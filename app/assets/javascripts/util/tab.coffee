# util/tab
class @EngrsmUtilTab

  # const
  ACTIVE_CLASS = 'active'
  CLICK = 'click'

  # create
  @createTab = (leftSwitch, rightSwitch, leftContent, rightContent, hiddenClass) ->

    # display both
    displayBothEditorAndPreview =->
      $(leftContent).removeClass(hiddenClass)
      $(rightContent).removeClass(hiddenClass)
      $(leftSwitch).parent().removeClass(ACTIVE_CLASS)
      $(rightSwitch).parent().removeClass(ACTIVE_CLASS)
  
    # display editor
    $(leftSwitch).on CLICK, ->
      displayBothEditorAndPreview()
      $(rightContent).addClass(hiddenClass)
      $(leftSwitch).parent().addClass(ACTIVE_CLASS)
  
    # display preview
    $(rightSwitch).on CLICK, ->
      displayBothEditorAndPreview()
      $(leftContent).addClass(hiddenClass)
      $(rightSwitch).parent().addClass(ACTIVE_CLASS)

  # rewrite query
  @rewriteQuery = (buttons, queries) ->
    # validate
    return if buttons.length != queries.length # args
    return unless history.state != undefined # browther (e.g. Android 3.x)
    # function
    action = (button, query) ->
      $(button).on CLICK, ->
        path = location.pathname + query
        history.replaceState(history.state, null, path)
    # button -> query
    for i in [0..buttons.length-1]
      action(buttons[i], queries[i])
