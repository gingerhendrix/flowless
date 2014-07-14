class App.Views.NewItem.Select extends Darwin.View
  @options {
    selectors: {
      new_item_selector: 'select#available_flows'
      new_item_button: 'button#add_new_item'
    }
  }

  disableNewItemButton: ->
    @get('new_item_button').prop('disabled', true)

  enableNewItemButton: ->
    @get('new_item_button').prop('disabled', false)