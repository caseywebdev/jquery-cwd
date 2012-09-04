# Everyone's favorite cheat code
$.Konami = (callback, options = {}) ->
  options = _.extend
    onlyOnce: false
    code: '38,38,40,40,37,39,37,39,66,65,13'
    touchCode: 'up,up,down,down,left,right,left,right,tap,tap,tap'
  , options
  keysPressed = []
  touchEvents = []
  tap = false
  startX = startY = dX = dY = 0
  keyDownEvent = (e) ->
    keysPressed.push e.keyCode
    if _.endsWith keysPressed + '', options.code
      $(document).off 'keydown', keyDownEvent if options.onlyOnce
      keysPressed = []
      e.preventDefault()
      callback()
  touchStartEvent = (e) ->
    e = e.originalEvent
    if e.touches.length is 1
      touch = e.touches[0]
      {screenX: startX, screenY: startY} = touch
      tap = tracking = true
  touchMoveEvent = (e) ->
    e = e.originalEvent
    if e.touches.length is 1 and tap
      touch = e.touches[0]
      dX = touch.screenX - startX
      dY = touch.screenY - startY
      rightLeft = if dX > 0 then 'right' else 'left'
      downUp = if dY > 0 then 'down' else 'up'
      val = if Math.abs(dX) > Math.abs dY then rightLeft else downUp
      touchEvents.push val
      tap = false
      checkEvents e
  touchEndEvent = (e) ->
    e = e.originalEvent
    if e.touches.length is 0 and tap
      touchEvents.push 'tap'
      checkEvents e
  checkEvents = (e) ->
    if _.endsWith touchEvents + '', options.touchCode
      if options.onlyOnce
        $(document).off 'touchmove', touchMoveEvent
        $(document).off 'touchend', touchEndEvent
      touchEvents = []
      e.preventDefault()
      callback()
  $(document).on 'keydown', keyDownEvent
  $(document).on 'touchstart', touchStartEvent
  $(document).on 'touchmove', touchMoveEvent
  $(document).on 'touchend', touchEndEvent
