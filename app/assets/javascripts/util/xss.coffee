# util/xss
class @EngrsmUtilXss

  # same as: forms/tale_form#escape
  @escapeString = (string) ->
    String(string).replace(/[&<>"'`=\/]/g, '').trim()
