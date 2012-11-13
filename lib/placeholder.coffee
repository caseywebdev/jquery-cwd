Placeholder =

  # Hijack jQuery's .val() so it will return an empty string if placeholder
  # says it should
  init: _.once ->
    val = $.fn.val
    $.fn.val = (str) ->
      $t = $ @
      data = $t.data() or {}
      if str is undefined
        if data.placeholderIsEmpty then '' else val.call $t
      else
        if data.placeholderIsEmpty? and not $t.is ':focus'
          if str in ['', null]
            $t.data placeholderIsEmpty: true
            val.call $t, data.placeholderText
            $t[0].type = 'text' if data.placeholderIsPassword
          else
            val.call $t, str
            $t[0].type = 'password' if data.placeholderIsPassword
            $t.data placeholderIsEmpty: false
        else
          val.call $t, str
        $t

  listeners:
    focus: ->
      $t = $ @
      _.defer ->
        $t[0].type = 'password' if $t.data().placeholderIsPassword
        $t.val '' if $t.data().placeholderIsEmpty
        $t.data placeholderIsEmpty: false

    blur: ->
      $t = $ @
      _.defer ->
        $t.val '' unless $t.val()

# Expose to jQuery
$.fn.placeholder = (text, options = {}) ->
  {password} = options

  # Run the highjack function if it hasn't been run yet
  Placeholder.init()

  $(@).each ->
    unless ($t = $ @).data().placeholderIsEmpty?
      $t[0].type = 'password' if password
      $t.data
        placeholderText: text
        placeholderIsEmpty: false
        placeholderIsPassword: password
      $t.val '' if not $t.val() or $t.val() is text
      $t.attr(
          placeholder: text
          title: text
        )
        .on Placeholder.listeners

