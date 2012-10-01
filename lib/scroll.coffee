# A quick zip to the top of the page, or optionally to an integer or
# jQuery object specified by `val`
$.fn.scrollTo = (val = 0, options = {}) ->
  val = val.offset().top if val instanceof $
  $(@).animate scrollTop: val, options

# Static version that defaults to the body/document (browser specific)
$.scrollTo = ->
  $el = $ if $.browser.webkit then document.body else document.documentElement
  $el.scrollTo arguments...

# Sometimes it's handy to know the size of the scrollbars in a browser
$.scrollbarSize = (dimension = 'width') ->
  $out = $('<div><div/></div>')
    .appendTo('body')
    .css
      position: 'fixed'
      overflow: 'hidden'
      left: -50
      top: -50
      width: 50
      height: 50
  $in = $out.find('> div').css height: '100%'
  d1 = $in[dimension]()
  $out.css overflow: 'scroll'
  d2 = $in[dimension]()
  $out.remove()
  d1 - d2

# Does the element have a scrollbar?
$.fn.hasScrollbar = ->
  $t = $ @
  style = $t.attr 'style'
  d1 = $t.width()
  d2 = $t.css(overflow: 'hidden').width()
  if style?
    $t.attr style: style
  else
    $t.removeAttr 'style'
  d1 isnt d2
