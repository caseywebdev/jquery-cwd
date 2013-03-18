# Yay tooltips!
Tooltip =

  # Store mouse coordinates
  mouse:
    x: 0
    y: 0

  # Set events on document to track changes
  init: _.once ->
    $('body').mousemove (e) ->
      Tooltip.mouse =
        x: e.pageX
        y: e.pageY

  listeners:
    mousemove: ->
      if ($t = $ @).data 'tooltip$Div'
        $t.data().tooltip$Div.css Tooltip.position($t).home

    mouseenter: ->
      Tooltip.show $t = $ @
      $t.data tooltipHover: true

    mouseleave: ->
      ($t = $ @).data tooltipHover: false
      Tooltip.hide $t

    focus: -> Tooltip.show $ @

    blur: -> Tooltip.hide $ @

  add: ($els, options = {}) ->
    $els.data
      tooltipHtml: options.html ? ''
      tooltipPosition: options.position ? 'top'
      tooltipOffset: options.offset ? 0
      tooltipDuration: options.duration ? 0
      tooltipNoHover: options.noHover ? false
      tooltipNoFocus: options.noFocus ? false
      tooltipMouse: options.mouse ? false
      tooltipHoverable: options.hoverable ? false
    $els.on 'mousemove', Tooltip.listeners.mousemove if options.mouse
    unless options.noHover
      $els.on 'mouseenter', Tooltip.listeners.mouseenter
      $els.on 'mouseleave', Tooltip.listeners.mouseleave
    unless options.noFocus
      $els.on 'focus', Tooltip.listeners.focus
      $els.on 'blur', Tooltip.listeners.blur
    $els

  # Get the current tooltip$Div for an item or create a new one and return that
  divFor: ($t) ->
    unless $t.data 'tooltip$Div'
      if $t.parent().css('position') is 'static'
        $t.parent().css position: 'relative'
      $t.data tooltipHoverable: false if $t.data().tooltipMouse
      $t.data _.extend
        tooltipPosition: 'top'
        tooltipOffset: 0
        tooltipDuration: 0
      , $t.data()
      $div = $('<div>')
        .addClass("tooltip #{$t.data().tooltipPosition}")
        .css(
          display: 'none'
          position: 'absolute'
          zIndex: 999999;
        )
        .append $('<div>')
          .html($t.data().tooltipHtml)
          .css
            position: 'relative'
      $t
        .data(tooltip$Div: $div)
        .parent()
        .append $div
      position = Tooltip.position $t
      $div
        .css(position.home)
        .find('> div')
        .css _.extend {opacity: 0}, position.away

      # If the tooltip is 'hoverable' (aka it should stay while the mouse is
      # over the tooltip itself)
      if $t.data().tooltipHoverable
        $div.hover ->
          Tooltip.show $t
          $t.data tooltipHoverableHover: true
        , ->
          $t.data tooltipHoverableHover: false
          Tooltip.hide $t
      else

        # Otherwise turn off interaction with the mouse
        $div.css
          pointerEvents: 'none'
          '-webkit-user-select': 'none'
          '-moz-user-select': 'none'
          userSelect: 'none'

    # Finally, return the div
    $t.data 'tooltip$Div'

  # Show the tooltip if it's not already visible
  show: ($t) ->
    $div = Tooltip.divFor $t
    unless (not $t.data().tooltipNoHover and $t.data().tooltipHover) or
            (not $t.data().tooltipNoFocus and $t.is ':input:focus') or
            $t.data().tooltipHoverableHover
      position = Tooltip.position $t
      $div
        .appendTo($t.parent())
        .css(_.extend {display: 'block'}, position.home)
        .find('> div')
        .stop()
        .animate
          opacity: 1
          top: 0
          left: 0
        , $t.data().tooltipDuration

  # Hide the tooltip if it's not already hidden
  hide: ($t) ->
    if $div = $t.data 'tooltip$Div'
      unless (not $t.data().tooltipNoHover and $t.data().tooltipHover) or
              (not $t.data().tooltipNoFocus and $t.is ':input:focus') or
              $t.data().tooltipHoverableHover
        position = Tooltip.position $t
        $div
          .css(position.home)
          .find('> div')
          .stop()
          .animate _.extend({opacity: 0}, position.away),
            duration: $t.data().tooltipDuration
            complete: ->
              $t.data tooltip$Div: null
              $(@).parent().remove()

  # Method for getting the correct CSS position data for a tooltip
  position: ($t) ->
    $div = $t.data 'tooltip$Div'
    $parent = $t.parent()
    offset = $t.data().tooltipOffset
    divWidth = $div.outerWidth()
    divHeight = $div.outerHeight()
    parentScrollLeft = $parent.scrollLeft()
    parentScrollTop = $parent.scrollTop()
    if $t.data().tooltipMouse
      tLeft = Tooltip.mouse.x - $t.parent().offset().left + parentScrollLeft
      tTop = Tooltip.mouse.y - $t.parent().offset().top + parentScrollTop
      tWidth = tHeight = 0
    else
      tPosition = $t.position()
      tLeft = tPosition.left + parentScrollLeft + parseInt $t.css 'marginLeft'
      tTop = tPosition.top + parentScrollTop + parseInt $t.css 'marginTop'
      tWidth = $t.outerWidth()
      tHeight = $t.outerHeight()
    home =
      left: tLeft
      top: tTop
    away = {}
    switch $t.data().tooltipPosition
      when 'top'
        home.left += (tWidth - divWidth)/2
        home.top -= divHeight
        away.top = -offset
      when 'right'
        home.left += tWidth
        home.top += (tHeight - divHeight)/2
        away.left = offset
      when 'bottom'
        home.left += (tWidth - divWidth)/2
        home.top += tHeight
        away.top = offset
      when 'left'
        home.left -= divWidth
        home.top += (tHeight - divHeight)/2
        away.left = -offset
    {home, away}

# Expose to jQuery
$.extend $.fn,
  tooltip: (options) ->
    Tooltip.init()
    Tooltip.add $(@), options

  # Use this to correct the tooltip content and positioning between events if
  # necessary
  correctTooltip: ->
    $(@).each ->
      $t = $ @
      $div = $t.data 'tooltip$Div'
      if $div
        if $t.css('display') is 'none'
          $t.mouseleave().blur()
        else
          $div.find('> div').html($t.data().tooltipHtml)
          $div.css Tooltip.position($t).home

  # Use this to remove a tooltip
  resetTooltip: -> $(@).each -> $(@).data().tooltip$Div?.remove()
