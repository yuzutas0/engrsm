# tales/form
@my100tales_tales_index = ->

  # const
  VUE_SEARCH_ID = 'script__tale__index__search'
  VUE_SEARCH_DOM = '#' + VUE_SEARCH_ID

  # check DOM
  if document.getElementById(VUE_SEARCH_ID) != null

    # modal
    @My100TalesUtilModal.createModal(VUE_SEARCH_DOM)
