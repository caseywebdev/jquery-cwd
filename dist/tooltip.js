// Generated by CoffeeScript 1.4.0
(function() {
  var Tooltip;

  Tooltip = {
    mouse: {
      x: 0,
      y: 0
    },
    init: _.once(function() {
      return $('body').mousemove(function(e) {
        return Tooltip.mouse = {
          x: e.pageX,
          y: e.pageY
        };
      });
    }),
    listeners: {
      mousemove: function() {
        var $t;
        if (($t = $(this)).data('tooltip$Div')) {
          return $t.data().tooltip$Div.css(Tooltip.position($t).home);
        }
      },
      mouseenter: function() {
        var $t;
        Tooltip.show($t = $(this));
        return $t.data({
          tooltipHover: true
        });
      },
      mouseleave: function() {
        var $t;
        ($t = $(this)).data({
          tooltipHover: false
        });
        return Tooltip.hide($t);
      },
      focus: function() {
        return Tooltip.show($(this));
      },
      blur: function() {
        return Tooltip.hide($(this));
      }
    },
    add: function($els, options) {
      var _ref, _ref1, _ref2, _ref3, _ref4, _ref5, _ref6, _ref7;
      if (options == null) {
        options = {};
      }
      $els.data({
        tooltipHtml: (_ref = options.html) != null ? _ref : '',
        tooltipPosition: (_ref1 = options.position) != null ? _ref1 : 'top',
        tooltipOffset: (_ref2 = options.offset) != null ? _ref2 : 0,
        tooltipDuration: (_ref3 = options.duration) != null ? _ref3 : 0,
        tooltipNoHover: (_ref4 = options.noHover) != null ? _ref4 : false,
        tooltipNoFocus: (_ref5 = options.noFocus) != null ? _ref5 : false,
        tooltipMouse: (_ref6 = options.mouse) != null ? _ref6 : false,
        tooltipHoverable: (_ref7 = options.hoverable) != null ? _ref7 : false
      });
      if (options.mouse) {
        $els.on('mousemove', Tooltip.listeners.mousemove);
      }
      if (!options.noHover) {
        $els.on('mouseenter', Tooltip.listeners.mouseenter);
        $els.on('mouseleave', Tooltip.listeners.mouseleave);
      }
      if (!options.noFocus) {
        $els.on('focus', Tooltip.listeners.focus);
        $els.on('blur', Tooltip.listeners.blur);
      }
      return $els;
    },
    divFor: function($t) {
      var $div, position;
      if (!$t.data('tooltip$Div')) {
        if ($t.parent().css('position') === 'static') {
          $t.parent().css({
            position: 'relative'
          });
        }
        if ($t.data().tooltipMouse) {
          $t.data({
            tooltipHoverable: false
          });
        }
        $t.data(_.extend({
          tooltipPosition: 'top',
          tooltipOffset: 0,
          tooltipDuration: 0
        }, $t.data()));
        $div = $('<div>').addClass("tooltip " + ($t.data().tooltipPosition)).css({
          display: 'none',
          position: 'absolute',
          zIndex: 999999
        }).append($('<div>').html($t.data().tooltipHtml).css({
          position: 'relative'
        }));
        $t.data({
          tooltip$Div: $div
        }).parent().append($div);
        position = Tooltip.position($t);
        $div.css(position.home).find('> div').css(_.extend({
          opacity: 0
        }, position.away));
        if ($t.data().tooltipHoverable) {
          $div.hover(function() {
            Tooltip.show($t);
            return $t.data({
              tooltipHoverableHover: true
            });
          }, function() {
            $t.data({
              tooltipHoverableHover: false
            });
            return Tooltip.hide($t);
          });
        } else {
          $div.css({
            pointerEvents: 'none',
            '-webkit-user-select': 'none',
            '-moz-user-select': 'none',
            userSelect: 'none'
          });
        }
      }
      return $t.data('tooltip$Div');
    },
    show: function($t) {
      var $div, position;
      $div = Tooltip.divFor($t);
      if (!((!$t.data().tooltipNoHover && $t.data().tooltipHover) || (!$t.data().tooltipNoFocus && $t.is(':input:focus')) || $t.data().tooltipHoverableHover)) {
        position = Tooltip.position($t);
        return $div.appendTo($t.parent()).css(_.extend({
          display: 'block'
        }, position.home)).find('> div').stop().animate({
          opacity: 1,
          top: 0,
          left: 0
        }, $t.data().tooltipDuration);
      }
    },
    hide: function($t) {
      var $div, position;
      if ($div = $t.data('tooltip$Div')) {
        if (!((!$t.data().tooltipNoHover && $t.data().tooltipHover) || (!$t.data().tooltipNoFocus && $t.is(':input:focus')) || $t.data().tooltipHoverableHover)) {
          position = Tooltip.position($t);
          return $div.css(position.home).find('> div').stop().animate(_.extend({
            opacity: 0
          }, position.away), {
            duration: $t.data().tooltipDuration,
            complete: function() {
              $t.data({
                tooltip$Div: null
              });
              return $(this).parent().remove();
            }
          });
        }
      }
    },
    position: function($t) {
      var $div, $parent, away, divHeight, divWidth, home, offset, parentScrollLeft, parentScrollTop, tHeight, tLeft, tPosition, tTop, tWidth;
      $div = $t.data('tooltip$Div');
      $parent = $t.parent();
      offset = $t.data().tooltipOffset;
      divWidth = $div.outerWidth();
      divHeight = $div.outerHeight();
      parentScrollLeft = $parent.scrollLeft();
      parentScrollTop = $parent.scrollTop();
      if ($t.data().tooltipMouse) {
        tLeft = Tooltip.mouse.x - $t.parent().offset().left + parentScrollLeft;
        tTop = Tooltip.mouse.y - $t.parent().offset().top + parentScrollTop;
        tWidth = tHeight = 0;
      } else {
        tPosition = $t.position();
        tLeft = tPosition.left + parentScrollLeft + parseInt($t.css('marginLeft'));
        tTop = tPosition.top + parentScrollTop + parseInt($t.css('marginTop'));
        tWidth = $t.outerWidth();
        tHeight = $t.outerHeight();
      }
      home = {
        left: tLeft,
        top: tTop
      };
      away = {};
      switch ($t.data().tooltipPosition) {
        case 'top':
          home.left += (tWidth - divWidth) / 2;
          home.top -= divHeight;
          away.top = -offset;
          break;
        case 'right':
          home.left += tWidth;
          home.top += (tHeight - divHeight) / 2;
          away.left = offset;
          break;
        case 'bottom':
          home.left += (tWidth - divWidth) / 2;
          home.top += tHeight;
          away.top = offset;
          break;
        case 'left':
          home.left -= divWidth;
          home.top += (tHeight - divHeight) / 2;
          away.left = -offset;
      }
      return {
        home: home,
        away: away
      };
    }
  };

  $.extend($.fn, {
    tooltip: function(options) {
      Tooltip.init();
      return Tooltip.add($(this), options);
    },
    correctTooltip: function() {
      return $(this).each(function() {
        var $div, $t;
        $t = $(this);
        $div = $t.data('tooltip$Div');
        if ($div) {
          if ($t.css('display') === 'none') {
            return $t.mouseleave().blur();
          } else {
            $div.find('> div').html($t.data().tooltipHtml);
            return $div.css(Tooltip.position($t).home);
          }
        }
      });
    },
    resetTooltip: function() {
      return $(this).each(function() {
        var _ref;
        return (_ref = $(this).data().tooltip$Div) != null ? _ref.remove() : void 0;
      });
    }
  });

}).call(this);
