# scores/form
@engrsm_scores_form = ->

  # loop for score index
  index = 0
  while true
    index++

    # DOM
    # const
    VUE_EDIT_ID = "script__score__" + index
    VUE_EDIT_DOM = "#" + VUE_EDIT_ID
    # check
    if document.getElementById(VUE_EDIT_ID) == null
      break

    # modal
    EngrsmUtilModal.createModal(VUE_EDIT_DOM)
