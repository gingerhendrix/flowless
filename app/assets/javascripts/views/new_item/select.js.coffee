class App.Views.NewItem.Select extends Darwin.View
  @options {
    selectors: {
      new_item_selector:      'select#available_flows'
      new_item_button:        'button#add_new_item'
    }
  }

  disableNewItemButton: ->
    @get('new_item_button').button('loading')

  enableNewItemButton: ->
    @get('new_item_button').button('reset')

  deactivateNewItemButton: ->
    button = @get('new_item_button')
    button.button('reset')
    window.setTimeout( ( ->( button.prop('disabled', true) ) ), 0) # Workaround to disables the button correctly, see: https://github.com/twbs/bootstrap/issues/6242