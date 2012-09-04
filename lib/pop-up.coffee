# Multipurpose PopUp
PopUp =

  # Build the PopUp element
  bind: =>

    # Until 'display: box' becomes more widely available, we're stuck with
    # table/table-cell
    $('body').append PopUp.$container = $('<div>')
      .attr(id: 'js-pop-up-container')
      .css(
        display: 'none'
        position: 'fixed'
        zIndex: 999999
        left: 0
        top: 0
        width: '100%'
        height: '100%'
        opacity: 0
        overflow: 'auto'
      )
      .append $('<div>')
        .attr(id: 'js-pop-up-table')
        .css(
          display: 'table'
          width: '100%'
          height: '100%'
        )
        .append $('<div>')
          .attr(id: 'js-pop-up-table-cell')
          .css(
            display: 'table-cell'
            textAlign: 'center'
            verticalAlign: 'middle'
          )
          .append PopUp.$div = $('<div>')
            .attr(id: 'js-pop-up')
            .css
              display: 'inline-block'
              position: 'relative'
    $.PopUp.hide()
    PopUp.$container.on 'click', ->
      PopUp.$div.find('.js-pop-up-outside').click()
    PopUp.$div
      .on('click', (e) -> e.stopPropagation())
      .on 'click', '.js-pop-up-hide', -> $.PopUp.hide
    $(document).keydown (e) ->
      if PopUp.$container.css('display') is 'block' and
          not $('body :focus').length
        switch e.keyCode
          when 13 then PopUp.$div.find('.js-pop-up-enter').click()
          when 27 then PopUp.$div.find('.js-pop-up-esc').click()
          else return true
        false

PopUp.init = _.once PopUp.bind

# Expose to jQuery
$.PopUp =

  # Duration and Fade duration default, feel free to override
  duration: 0
  fadeDuration: 250

  # Show the PopUp with the given `el`, optionally for a 'duration', with a
  # 'callback', and/or with a 'fadeDuration'
  show: (el, options = {}) ->

    # Build the PopUp element once
    PopUp.init()

    # Default options
    options = _.extend
      duration: $.PopUp.duration
      callback: null
      fadeDuration: $.PopUp.fadeDuration
    , options

    $body = $ 'body'
    unless PopUp.$container.css('display') is 'block'
      PopUp.bodyStyle = $body.attr 'style'
    $body.css marginRight: $.scrollbarSize() if $('body').hasScrollbar()
    $body
      .css(overflow: 'hidden')
      .find(':focus').blur()

    PopUp.fadeDuration = options.fadeDuration
    PopUp.$div.empty()
    if typeof el is 'string'
      PopUp.$div.html el
    else
      PopUp.$div.append el

    PopUp.$container
      .stop()
      .css(display: 'block')
      .animate
        opacity: 1
      , options.fadeDuration

    clearTimeout PopUp.timeout
    PopUp.timeout = _.delay ->
      $.PopUp.hide()
      options.callback?()
    , options.duration if options.duration

  # Fade the PopUp out
  hide: (fadeDuration = PopUp.fadeDuration) ->
    return unless PopUp.$container
    PopUp.$container
      .stop()
      .animate
        opacity: 0
      , fadeDuration
      , ->
        PopUp.$container.css display: 'none'
        if PopUp.bodyStyle
          $('body').attr style: PopUp.saveBodyStyle
        else
          $('body').removeAttr 'style'
        delete PopUp.bodyStyle
