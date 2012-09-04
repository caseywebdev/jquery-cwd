# Search (as you type)
Search =

  # Dirty string? Clean it up!
  clean: (str) ->
    str.toLowerCase().replace(/\s{2,}/g, ' ').replace /^\s*|\s*$/g, ''

  # Change the current search results page
  page: ($searches, n, prev) ->
    $searches.each ->
      $search = $ @
      $results = $search.data 'search$Results'
      n = Math.min $results.find('.page').length - 1, Math.max n, 0
      $results.find('.selected').removeClass 'selected'
      $results.find('.page')
        .css(display: 'none')
        .eq(n)
        .removeAttr('style')
        .find('.result:not(.prev):not(.next)')[if prev then 'last' else 'first']()
        .addClass 'selected'
      $search.data 'searchPage', n

  # Send the value of q to the correct search function and return the result to the correct callback
  query: ($searches, urlN = 1) ->
    $searches.each ->
      o = Search
      $search = $ @
      $results = $search.data 'search$Results'
      $q = $search.data 'search$Q'
      callback = $search.data().searchCallback
      q = Search.clean $q.val()
      t = new Date().getTime()
      $results.css display: 'block'
      anotherSearch = $search.data("searchUrl#{urlN + 1}")?
      unless q or $search.data('empty')?
        $results.css(display: 'none').empty()
        $search.removeClass 'loading'
      else if q isnt $search.data().searchLastQ or urlN > 1
        $search.addClass 'loading'
        callback $search, null, urlN
        clearTimeout $search.data().searchTimeout
        $search.data().searchAjax.abort?()
        if $search.data().searchCache["#{urlN}_" + q]?
          $search.removeClass 'loading' unless anotherSearch
          callback $search, $search.data().searchCache["#{urlN}_" + q], urlN
          o.query $search, urlN + 1 if anotherSearch
        else
          $search.data 'searchTimeout',
            setTimeout ->
              handleData = (data) ->
                $search.data().searchCache["#{urlN}_" + q] = data
                if check is $search.data().searchId and (_.clean($q.val()) or $search.data('empty')?)
                  $search.removeClass 'loading' unless anotherSearch
                  callback $search, data, urlN
                o.query $search, urlN + 1 if anotherSearch
              check = $search.data(searchId: $search.data().searchId + 1).data().searchId
              if $search.data().searchJs
                handleData $search.data().searchJs q
              else if $search.data().searchUrl?
                $search.data searchAjax: $.getJSON($search.data("searchUrl#{if urlN is 1 then '' else urlN}"), q: q, handleData)
            , $search.data().searchDelay ? 0
      $search.data 'searchLastQ', q

  # Select the next or previous in a list of results
  select: ($searches, dir) ->
    $searches.each ->
      o = Search
      $search = $ @
      $page = $search.find('.page').eq $search.data().searchPage
      unless $page.find('.selected').removeClass('selected')[dir]().addClass('selected').length
        $page.find('.result')[if dir is 'prev' then 'first' else 'last']().addClass 'selected'
      if $page.find('.result.selected.prev').length
        o.page $search, $search.data().searchPage - 1, true
      else if $page.find('.result.selected.next').length
        o.page $search, $search.data().searchPage + 1

# Expose to jQuery
$.fn.search = ($q, $results, options = {}) ->
  $search = $ @
  unless $search.data().searchCache?
    o = Search
    $search.data
      searchCache: []
      searchId: 0
      searchAjax: {}
      searchLastQ: null
      searchPage: 0
      searchHoldHover: false
      search$Q: $q
      search$Results: $results

    for key, val of options
      $search.data "search#{key.replace /(\w)/, (s) -> s.toUpperCase()}", val

    o.query $search if $q.is ':focus'
    $search
      .hover(->
        $search.data searchHover: true
      , ->
        $search.data searchHover: false
        $results.css display: 'none' unless $q.is(':focus') or
          $search.data().searchHoldHover
      )
      .mouseover ->
        $search.data searchHoldHover: false

    $q
      .blur(-> _.defer -> $results.css display: 'none' unless $search.data().searchHover)
      .focus(-> $search.data searchHoldHover: false)
      .keydown((e) ->
        switch e.keyCode
          when 13 then $search.find('.selected').click()
          when 38 then o.select $search, 'prev'
          when 40 then o.select $search, 'next'
          when 27
            if $q.val() is ''
              $q.blur()
              _.defer ->
                o.query $search
            else
              _.defer ->
                $q.val ''
                o.query $search
          else
            _.defer -> o.query $search if $q.is ':focus'
            return true
        false
      )
      .on 'focus keyup change', -> o.query $search

    $results.on 'mouseenter click', '.result', (e) ->
      $t = $ @
      $results.find('.result.selected').removeClass 'selected'
      $t.addClass 'selected'
      if e.type is 'click'
        if $t.hasClass 'prev'
          o.page $search, $search.data().searchPage - 1, true
          $search.data searchHoldHover: true
        else if $t.hasClass 'next'
          o.page $search, $search.data().searchPage + 1
          $search.data searchHoldHover: true
        else if $t.hasClass 'submit'
          $t.parents('form').submit()
        if $t.hasClass 'hide'
          $q.blur()
          $results.css display: 'none'
