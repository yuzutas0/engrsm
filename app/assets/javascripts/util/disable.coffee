# util/disable
class @EngrsmUtilDisable

  setDisabledOne = (trigger, target) ->
    $(target).prop('disabled', !($(trigger).is(':checked')))
    $(trigger).on 'click', ->
      $(target).prop('disabled', !($(trigger).is(':checked')))

  @setDisabled = (trigger, targets...) ->
    setDisabledOne(trigger, target) for target in targets
