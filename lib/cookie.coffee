# Making Cookie management easy on you
$.Cookie = (name, val, options = {}) ->
  if typeof name is 'object'
    $.Cookie n, v, val for n, v of name
    $.Cookie()
  else if typeof name is 'string' and val isnt undefined
    options.expires = -1 if val is null
    val ||= ''
    params = []
    params.push "; Expires=#{
      if options.expires.toGMTString?
      then options.expires.toGMTString()
      else new Date(+new Date + options.expires).toGMTString()
    }" if options.expires
    params.push "; Path=#{options.path}" if options.path
    params.push "; Domain=#{options.domain}" if options.domain
    params.push '; HttpOnly' if options.httpOnly
    params.push '; Secure' if options.secure
    encodeName = encodeURIComponent name
    encodeVal = encodeURIComponent val
    document.cookie = "#{encodeName}=#{encodeVal}#{params.join ''}"
    $.Cookie()
  else
    cookies = {}
    if document.cookie
      rawCookies = decodeURIComponent(document.cookie).split /\s*;\s*/
      for cookie in rawCookies
        {1: n, 2: v} = /^([^=]*)\s*=\s*(.*)$/.exec cookie
        if typeof name is 'string' and name is n
          return v
        else if not name
          cookies[n] = v
    if not name then cookies else null
