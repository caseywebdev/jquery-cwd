$.extend $.fn,
  # A backbone UI/model sync'r
  backboneLink = (options = {}) ->
    {model, attr, save} = options
    save ?= true
    $(@).each ->
      check = $(@).find '[data-backbone-link-attr]'
      (if check.length then check else $ @).each ->
        $t = $ @
        $t.backboneUnlink()
        $t.data backboneLinkModel: model
        checkbox = $t.is ':checkbox'
        # Define callback functions
        $t.data
          backboneLinkInputChange: ->
            oldVal = model.get attr
            newVal = if checkbox then $t.is ':checked' else $t.val()
            if attr is 'id' or
                _.endsWith(attr, '_id') or
                _.endsWith(attr, 'Id')
              newVal = if newVal then parseInt newVal else null
            model.set attr, if newVal is '' then null else newVal
            model.save() if save and newVal isnt oldVal

        $t.data
          backboneLinkModelChange: ->
            valOrText = if $t.is ':input' then 'val' else 'text'
            oldVal = if checkbox then $t.is ':checked' else $t[valOrText]()
            newVal = model.get attr
            newVal = if newVal is null then '' else newVal
            if newVal isnt oldVal
              if checkbox
                $t.prop checked: not not newVal
              else
                $t[valOrText] newVal

        # Bind change events
        $t.on 'change', $t.data().backboneLinkInputChange if $t.is ':input'

        # Bind and trigger the model change to update the element right now
        model.on "change:#{attr}", $t.data().backboneLinkModelChange
        $t.data().backboneLinkModelChange()

  # Remove the link to a backbone model
  backboneUnlink = ->
    $(@).each ->
      $t = $ @
      model = $t.data().backboneLinkModel
      if model
        $t.off 'change', $t.data().backboneLinkInputChange
        model.off null, $t.data().backboneLinkModelChange
