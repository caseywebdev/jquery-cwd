// Generated by CoffeeScript 1.4.0
(function() {

  $.fn.scrollTo = function(val, options) {
    if (val == null) {
      val = 0;
    }
    if (options == null) {
      options = {};
    }
    if (val instanceof $) {
      val = val.offset().top;
    }
    return $(this).animate({
      scrollTop: val
    }, options);
  };

  $.scrollTo = function() {
    var $el;
    $el = $($.browser.webkit ? document.body : document.documentElement);
    return $el.scrollTo.apply($el, arguments);
  };

  $.scrollbarSize = function(dimension) {
    var $in, $out, d1, d2;
    if (dimension == null) {
      dimension = 'width';
    }
    $out = $('<div><div/></div>').appendTo('body').css({
      position: 'fixed',
      overflow: 'hidden',
      left: -50,
      top: -50,
      width: 50,
      height: 50
    });
    $in = $out.find('> div').css({
      height: '100%'
    });
    d1 = $in[dimension]();
    $out.css({
      overflow: 'scroll'
    });
    d2 = $in[dimension]();
    $out.remove();
    return d1 - d2;
  };

  $.fn.hasScrollbar = function() {
    var $t, d1, d2, style;
    $t = $(this);
    style = $t.attr('style');
    d1 = $t.width();
    d2 = $t.css({
      overflow: 'hidden'
    }).width();
    if (style != null) {
      $t.attr({
        style: style
      });
    } else {
      $t.removeAttr('style');
    }
    return d1 !== d2;
  };

}).call(this);
