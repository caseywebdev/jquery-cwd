// Generated by CoffeeScript 1.4.0
(function() {
  var Search;

  Search = {
    clean: function(str) {
      return str.replace(/\s+/g, ' ').replace(/^\s*|\s*$/g, '');
    },
    query: function($searches, urlN) {
      if (urlN == null) {
        urlN = 1;
      }
      return $searches.each(function() {
        var $q, $results, $search, anotherSearch, callback, o, q, t, _base, _ref;
        o = Search;
        $search = $(this);
        $results = $search.data().search$Results;
        $q = $search.data().search$Q;
        callback = $search.data().searchCallback;
        q = o.clean($q.val());
        t = new Date().getTime();
        $results.css({
          display: 'block'
        });
        anotherSearch = $search.data("searchUrl" + (urlN + 1)) != null;
        if (!(q || $search.data().searchEmpty)) {
          $results.css({
            display: 'none'
          }).empty();
          $search.removeClass('loading');
        } else if (q !== $search.data().searchLastQ || urlN > 1) {
          $search.addClass('loading');
          callback($search, null, urlN);
          clearTimeout($search.data().searchTimeout);
          if (typeof (_base = $search.data().searchAjax).abort === "function") {
            _base.abort();
          }
          if ($search.data().searchCache[("" + urlN + "-") + q] != null) {
            if (!anotherSearch) {
              $search.removeClass('loading');
            }
            callback($search, $search.data().searchCache[("" + urlN + "-") + q], urlN);
            if (anotherSearch) {
              o.query($search, urlN + 1);
            }
          } else {
            $search.data({
              searchTimeout: _.delay(function() {
                var check, handleData;
                handleData = function(data) {
                  $search.data().searchCache[("" + urlN + "-") + q] = data;
                  if (check === $search.data().searchId && (o.clean($q.val()) || $search.data().empty)) {
                    if (!anotherSearch) {
                      $search.removeClass('loading');
                    }
                    callback($search, data, urlN);
                  }
                  if (anotherSearch) {
                    return o.query($search, urlN + 1);
                  }
                };
                check = $search.data({
                  searchId: $search.data().searchId + 1
                }).data().searchId;
                if ($search.data().searchJs) {
                  return handleData($search.data().searchJs(q));
                } else if ($search.data().searchUrl != null) {
                  return $search.data({
                    searchAjax: $.getJSON($search.data("searchUrl" + (urlN === 1 ? '' : urlN)), {
                      q: q
                    }, handleData)
                  });
                }
              }, (_ref = $search.data().searchDelay) != null ? _ref : 0)
            });
          }
        }
        return $search.data({
          searchLastQ: q
        });
      });
    },
    select: function($searches, dir) {
      return $searches.each(function() {
        var $current, $new, $results, $search, $selected, o, rHeight, rScrollTop, sHeight, sTop;
        o = Search;
        $search = $(this);
        $results = $search.data().search$Results;
        $current = $results.find('.selected');
        if (($new = $current[dir]()).length) {
          $current.removeClass('selected');
          ($selected = $new).addClass('selected');
        } else {
          $selected = $current;
        }
        rHeight = $results.height();
        rScrollTop = $results.scrollTop();
        sTop = $selected.position().top;
        sHeight = $selected.height();
        return $results.scrollTop(sTop + rScrollTop - (rHeight - sHeight) / 2);
      });
    }
  };

  $.extend($.fn, {
    search: function($q, $results, options) {
      if (options == null) {
        options = {};
      }
      return $(this).each(function() {
        var $search, key, o, val;
        $search = $(this);
        if (!$search.data().searchCache) {
          o = Search;
          $search.data({
            searchCache: [],
            searchId: 0,
            searchAjax: {},
            searchLastQ: null,
            searchHoldHover: false,
            search$Q: $q,
            search$Results: $results
          });
          for (key in options) {
            val = options[key];
            $search.data("search" + (key.replace(/(\w)/, function(s) {
              return s.toUpperCase();
            })), val);
          }
          if ($q.is(':focus')) {
            o.query($search);
          }
          $search.hover(function() {
            return $search.data({
              searchHover: true
            });
          }, function() {
            $search.data({
              searchHover: false
            });
            if (!($q.is(':focus') || $search.data().searchHoldHover)) {
              return $results.css({
                display: 'none'
              });
            }
          }).mouseover(function() {
            return $search.data({
              searchHoldHover: false
            });
          });
          $q.blur(function() {
            return _.defer(function() {
              if (!$search.data().searchHover) {
                return $results.css({
                  display: 'none'
                });
              }
            });
          }).focus(function() {
            return $search.data({
              searchHoldHover: false
            });
          }).keydown(function(e) {
            switch (e.keyCode) {
              case 13:
                $search.find('.selected').click();
                break;
              case 38:
                o.select($search, 'prev');
                break;
              case 40:
                o.select($search, 'next');
                break;
              case 27:
                if ($q.val() === '') {
                  $q.blur();
                  _.defer(function() {
                    return o.query($search);
                  });
                } else {
                  _.defer(function() {
                    $q.val('');
                    return o.query($search);
                  });
                }
                break;
              default:
                _.defer(function() {
                  if ($q.is(':focus')) {
                    return o.query($search);
                  }
                });
                return true;
            }
            return false;
          }).on('focus keyup change', function() {
            return o.query($search);
          });
          return $results.on('mouseenter click', '.result', function(e) {
            var $t;
            $t = $(this);
            $results.find('.result.selected').removeClass('selected');
            $t.addClass('selected');
            if (e.type === 'click') {
              if ($t.hasClass('submit')) {
                $t.parents('form').submit();
              }
              if ($t.hasClass('hide')) {
                $q.blur();
                return $results.css({
                  display: 'none'
                });
              }
            }
          });
        }
      });
    }
  });

}).call(this);
