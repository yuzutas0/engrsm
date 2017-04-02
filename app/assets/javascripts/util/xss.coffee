# util/xss
class @EngrsmUtilXss

  # same as: forms/post_form#escape
  @escapeString = (string) ->
    String(string).replace(/[&<>"'`=\/]/g, '').trim()
