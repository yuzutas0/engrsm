# tags/form
@engrsm_tags_form = ->

  # loop for tag index length - 0 for new
  index = -1
  while true
    index++

    # DOM
    # const
    VUE_EDIT_ID = "script__tag__" + index
    VUE_EDIT_DOM = "#" + VUE_EDIT_ID
    # check
    if document.getElementById(VUE_EDIT_ID) == null
      break

    # modal
    EngrsmUtilModal.createModal(VUE_EDIT_DOM)
