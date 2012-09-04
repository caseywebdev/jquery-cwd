// Generated by CoffeeScript 1.3.3
(function() {
  var PopUp,
    _this = this;

  PopUp = {
    bind: function() {
      $('body').append(PopUp.$container = $('<div>').attr({
        id: 'js-pop-up-container'
      }).css({
        display: 'none',
        position: 'fixed',
        zIndex: 999999,
        left: 0,
        top: 0,
        width: '100%',
        height: '100%',
        opacity: 0,
        overflow: 'auto'
      }).append($('<div>').attr({
        id: 'js-pop-up-table'
      }).css({
        display: 'table',
        width: '100%',
        height: '100%'
      }).append($('<div>').attr({
        id: 'js-pop-up-table-cell'
      }).css({
        display: 'table-cell',
        textAlign: 'center',
        verticalAlign: 'middle'
      }).append(PopUp.$div = $('<div>').attr({
        id: 'js-pop-up'
      }).css({
        display: 'inline-block',
        position: 'relative'
      })))));
      $.PopUp.hide();
      PopUp.$container.on('click', function() {
        return PopUp.$div.find('.js-pop-up-outside').click();
      });
      PopUp.$div.on('click', function(e) {
        return e.stopPropagation();
      }).on('click', '.js-pop-up-hide', function() {
        return $.PopUp.hide;
      });
      return $(document).keydown(function(e) {
        if (PopUp.$container.css('display') === 'block' && !$('body :focus').length) {
          switch (e.keyCode) {
            case 13:
              PopUp.$div.find('.js-pop-up-enter').click();
              break;
            case 27:
              PopUp.$div.find('.js-pop-up-esc').click();
              break;
            default:
              return true;
          }
          return false;
        }
      });
    }
  };

  PopUp.init = _.once(PopUp.bind);

  $.PopUp = {
    duration: 0,
    fadeDuration: 250,
    show: function(el, options) {
      var $body;
      if (options == null) {
        options = {};
      }
      PopUp.init();
      options = _.extend({
        duration: $.PopUp.duration,
        callback: null,
        fadeDuration: $.PopUp.fadeDuration
      }, options);
      $body = $('body');
      if (PopUp.$container.css('display') !== 'block') {
        PopUp.bodyStyle = $body.attr('style');
      }
      if ($('body').hasScrollbar()) {
        $body.css({
          marginRight: $.scrollbarSize()
        });
      }
      $body.css({
        overflow: 'hidden'
      }).find(':focus').blur();
      PopUp.fadeDuration = options.fadeDuration;
      PopUp.$div.empty();
      if (typeof el === 'string') {
        PopUp.$div.html(el);
      } else {
        PopUp.$div.append(el);
      }
      PopUp.$container.stop().css({
        display: 'block'
      }).animate({
        opacity: 1
      }, options.fadeDuration);
      clearTimeout(PopUp.timeout);
      if (options.duration) {
        return PopUp.timeout = _.delay(function() {
          $.PopUp.hide();
          return typeof options.callback === "function" ? options.callback() : void 0;
        }, options.duration);
      }
    },
    hide: function(fadeDuration) {
      if (fadeDuration == null) {
        fadeDuration = PopUp.fadeDuration;
      }
      if (!PopUp.$container) {
        return;
      }
      return PopUp.$container.stop().animate({
        opacity: 0
      }, fadeDuration, function() {
        PopUp.$container.css({
          display: 'none'
        });
        if (PopUp.bodyStyle) {
          $('body').attr({
            style: PopUp.saveBodyStyle
          });
        } else {
          $('body').removeAttr('style');
        }
        return delete PopUp.bodyStyle;
      });
    }
  };

}).call(this);
