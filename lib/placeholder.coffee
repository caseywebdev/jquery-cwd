Placeholder =

  # Hijack jQuery's .val() so it will return an empty string if placeholder
  # says it should
  bind: ->
    val = $.fn.val
    $.fn.val = (str) ->
      $t = $ @
      if str is undefined
        if $t.data().placeholderIsEmpty then '' else val.call $t
      else
        if $t.data().placeholderIsEmpty? and not $t.is ':focus'
          if str in ['', null]
            $t.data placeholderIsEmpty: true
            val.call $t, $t.data().placeholderText
            $t[0].type = 'text' if $t.data().placeholderIsPassword
          else
            val.call $t, str
            $t[0].type = 'password' if $t.data().placeholderIsPassword
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

Placeholder.init = _.once Placeholder.bind

# Expose to jQuery
$.fn.placeholder = (text, options = {}) ->
  {password} = options

  # Run the highjack function if it hasn't been run yet
  Placeholder.init()

  $(@).each ->
    unless ($t = $ @).data().placeholderIsEmpty?
      $t[0].type = 'password' if password
      unless password and $.browser.msie and
          $.browser.version.split('.')[0] < 9
        $t.data
          placeholderText: text
          placeholderIsEmpty: false
          placeholderIsPassword: text
        $t.val '' if not $t.val() or $t.val() is text
        $t.attr(
            placeholder: text
            title: text
          )
          .on Placeholder.listeners

