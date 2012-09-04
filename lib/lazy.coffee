# Load it right before you see it
Lazy =
  $els: $()

  bind: ->
    $(window).on 'scroll resize', ->
      Lazy.check Lazy.$els

  check: ($imgs) ->
    $imgs.each ->
      $t = $ @
      _.defer ->
        visible = _.reduce $t.parents(), (memo, parent) ->
          memo and $(parent).css('display') isnt 'none' and
            $(parent).css('visibility') isnt 'hidden'
        , true
        fold = $(window).scrollTop() + $(window).outerHeight()
        showLine = $t.offset().top - $t.data().lazyTolerance
        if visible and fold >= showLine
          $t.attr 'src', $t.data().lazySrc
          Lazy.$els = Lazy.$els.not $t
    $imgs

Lazy.init = _.once Lazy.bind

# Load images only when they're on the page or about to be on it
$.fn.lazy = (src, options = {}) ->
  {tolerance} = options
  tolerance ?= 100
  $t = $ @
  Lazy.init()
  Lazy.$els = Lazy.$els.add $t.data
    lazySrc: src
    lazyTolerance: tolerance
  Lazy.check $t
