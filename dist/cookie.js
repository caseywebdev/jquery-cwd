// Generated by CoffeeScript 1.4.0
(function() {

  $.Cookie = function(name, val, options) {
    var cookie, cookies, encodeName, encodeVal, n, params, rawCookies, v, _i, _len, _ref;
    if (options == null) {
      options = {};
    }
    if (typeof name === 'object') {
      for (n in name) {
        v = name[n];
        $.Cookie(n, v, val);
      }
      return $.Cookie();
    } else if (typeof name === 'string' && val !== void 0) {
      if (val === null) {
        options.expires = -1;
      }
      val || (val = '');
      params = [];
      if (options.expires) {
        params.push("; Expires=" + (options.expires.toGMTString != null ? options.expires.toGMTString() : new Date(+(new Date) + options.expires).toGMTString()));
      }
      if (options.path) {
        params.push("; Path=" + options.path);
      }
      if (options.domain) {
        params.push("; Domain=" + options.domain);
      }
      if (options.httpOnly) {
        params.push('; HttpOnly');
      }
      if (options.secure) {
        params.push('; Secure');
      }
      encodeName = encodeURIComponent(name);
      encodeVal = encodeURIComponent(val);
      document.cookie = "" + encodeName + "=" + encodeVal + (params.join(''));
      return $.Cookie();
    } else {
      cookies = {};
      if (document.cookie) {
        rawCookies = decodeURIComponent(document.cookie).split(/\s*;\s*/);
        for (_i = 0, _len = rawCookies.length; _i < _len; _i++) {
          cookie = rawCookies[_i];
          _ref = /^([^=]*)\s*=\s*(.*)$/.exec(cookie), n = _ref[1], v = _ref[2];
          if (typeof name === 'string' && name === n) {
            return v;
          } else if (!name) {
            cookies[n] = v;
          }
        }
      }
      if (!name) {
        return cookies;
      } else {
        return null;
      }
    }
  };

}).call(this);
