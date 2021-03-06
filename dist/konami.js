// Generated by CoffeeScript 1.4.0
(function() {

  $.Konami = function(callback, options) {
    var checkEvents, dX, dY, keyDownEvent, keysPressed, startX, startY, tap, touchEndEvent, touchEvents, touchMoveEvent, touchStartEvent;
    if (options == null) {
      options = {};
    }
    options = _.extend({
      onlyOnce: false,
      code: '38,38,40,40,37,39,37,39,66,65,13',
      touchCode: 'up,up,down,down,left,right,left,right,tap,tap,tap'
    }, options);
    keysPressed = [];
    touchEvents = [];
    tap = false;
    startX = startY = dX = dY = 0;
    keyDownEvent = function(e) {
      keysPressed.push(e.keyCode);
      if (_.endsWith(keysPressed + '', options.code)) {
        if (options.onlyOnce) {
          $(document).off('keydown', keyDownEvent);
        }
        keysPressed = [];
        e.preventDefault();
        return callback();
      }
    };
    touchStartEvent = function(e) {
      var touch, tracking;
      e = e.originalEvent;
      if (e.touches.length === 1) {
        touch = e.touches[0];
        startX = touch.screenX, startY = touch.screenY;
        return tap = tracking = true;
      }
    };
    touchMoveEvent = function(e) {
      var downUp, rightLeft, touch, val;
      e = e.originalEvent;
      if (e.touches.length === 1 && tap) {
        touch = e.touches[0];
        dX = touch.screenX - startX;
        dY = touch.screenY - startY;
        rightLeft = dX > 0 ? 'right' : 'left';
        downUp = dY > 0 ? 'down' : 'up';
        val = Math.abs(dX) > Math.abs(dY) ? rightLeft : downUp;
        touchEvents.push(val);
        tap = false;
        return checkEvents(e);
      }
    };
    touchEndEvent = function(e) {
      e = e.originalEvent;
      if (e.touches.length === 0 && tap) {
        touchEvents.push('tap');
        return checkEvents(e);
      }
    };
    checkEvents = function(e) {
      if (_.endsWith(touchEvents + '', options.touchCode)) {
        if (options.onlyOnce) {
          $(document).off('touchmove', touchMoveEvent);
          $(document).off('touchend', touchEndEvent);
        }
        touchEvents = [];
        e.preventDefault();
        return callback();
      }
    };
    $(document).on('keydown', keyDownEvent);
    $(document).on('touchstart', touchStartEvent);
    $(document).on('touchmove', touchMoveEvent);
    return $(document).on('touchend', touchEndEvent);
  };

}).call(this);
